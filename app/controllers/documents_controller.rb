class DocumentsController < ApplicationController
  def index
    @documents = policy_scope(Document).order(created_at: :asc)
    authorize @documents
  end

  def show
    @document = Document.find(params[:id])
    authorize @document

    @document_url = rails_blob_path(@document.file)

    if params[:page]
      page = params[:page].to_i
      redirect_to "#{@document_url}#page=#{page}", disposition: "preview"
    else
      redirect_to @document_url, disposition: "preview"
    end
  end

  def new
    @document = Document.build
    if params[:collection_id]
      @collection = Collection.find(params[:collection_id])
      @document.collection = @collection
    end
  end

  def create
    @document = Document.build(document_params)
    @document.file.attach(document_params[:file])

    if @document.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "documents",
            partial: "documents/document",
            collection: policy_scope(Document).all
          )
        end
        format.html do
          redirect_to documents_path, notice: "The document has been uploaded."
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def document_params
    params.require(:document).permit(:file, :collection_id)
  end
end
