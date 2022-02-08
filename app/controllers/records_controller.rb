class RecordsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_and_authorize, only: %i[show edit update destroy]

  def index
    # authorize Record
    @records = Record.all.order(created_at: :desc)
  end

  def show; end

  def new
    @record = Record.new
  end

  def edit; end

  def create
    # TODO: Record creation moved to model to handle all recordable types
    @record = Record.new(record_params)
    @record.account = current_account
    @record.creator = current_user
    respond_to do |format|
      if @record.save
        format.html { redirect_to record_url(@record), notice: 'Record was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to record_url(@record), notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @record.destroy

    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def load_and_authorize
    @record = Record.includes(:permission).find(params[:id])
    authorize @record
  end

  def record_params
    params.require(:record).permit(:recordable_id, :recordable_type, :title, :subtitle, :description)
  end
end
