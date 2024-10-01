class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def new
    @document = Document.build
  end

  def create
    @document = Document.build

    @document.file.attach(document_params[:file])
    @document.user = User.first

    if @document.save
      redirect_to documents_path, notice: "The document has been uploaded."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def document_params
    params.require(:document).permit(:file)
  end
end
