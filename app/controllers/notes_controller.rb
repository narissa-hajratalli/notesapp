class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :destroy]
  before_action :authorized

  # GET /notes that belong to a user
  def index
    @notes = Note.where(user_id: @user.id)
    # when you have a referenced relationship, it doesnt create a property called user
    # it makes a property called user_id
    # @user was defined in our application as @user = User.find_by(id: user_id)

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user_id = @user.id

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:message, :user_id)
      #the params that are sent in need to match the schema of note (:note) and message and user_id are what is sent in by the user
    end
end
