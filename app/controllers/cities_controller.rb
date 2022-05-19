require 'net/http'
require 'json'

class CitiesController < ApplicationController
  before_action :set_city, only: %i[ show edit update destroy ]

  # GET /cities or /cities.json
  def index
    @cities = City.all
  end

  # GET /cities/1 or /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities or /cities.json
  def create
    formatted_params = lookup_city(city_params)
    if formatted_params[:error].present?
      @city = City.new
      render_error(formatted_params, :new)
    else
      @city = City.new(formatted_params)

      respond_to do |format|
        if @city.save
          format.html { redirect_to city_url(@city), notice: "City was successfully created." }
          format.json { render :show, status: :created, location: @city }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @city.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /cities/1 or /cities/1.json
  def update
    formatted_params = lookup_city(city_params)
    if formatted_params[:error].present?
      render_error(formatted_params, :edit)
    else
      respond_to do |format|
        if @city.update(formatted_params)
          format.html { redirect_to city_url(@city), notice: "City was successfully updated." }
          format.json { render :show, status: :ok, location: @city }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @city.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /cities/1 or /cities/1.json
  def destroy
    @city.destroy

    respond_to do |format|
      format.html { redirect_to cities_url, notice: "City was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def city_params
      values = params.fetch(:city, {}).permit(:name, :region, :country_id)
      if values[:region].is_a?(String) && values[:region].strip.size == 0
        values[:region] = nil
      end
      values
    end

    def lookup_city(params)
      name = params[:name]
      region = params[:region]
      country = Country.find(params[:country_id])
      location = if region.nil?
        "#{name},#{country.code}"
      else
        "#{name},#{region},#{country.code}"
      end

      request_url = "http://api.openweathermap.org/geo/1.0/direct?q=#{location}&limit=1&appid=#{ENV["OPENWEATHER_SECRET"]}"

      begin
        response = Rails.cache.fetch(request_url, :expires => 1.day) do
            Net::HTTP.get_response(URI(request_url))
        end
        if response.code == "200"
          body = JSON.parse(response.body)
          if body.size > 0 && body[0]["name"] == name
            city = body[0]
            {
              name: city["name"],
              region: city["state"],
              country: country,
              lat: city["lat"],
              long: city["lon"],
            }
          else
            { error: "no such city" }
          end
        else
          { error: response.message }
        end
      rescue =>e
        { error: e.message }
      end
    end

    def render_error(formatted_params, template)
      @city.errors.add(:name, :invalid, message: formatted_params[:error])
      respond_to do |format|
        format.html { render template, status: :unprocessable_entity }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
end
