class CollectionsController < ApplicationController
  def index
    @collections = policy_scope(Collection)
    authorize @collections
  end

  def show
    @collection = Collection.find(params[:id])
    @documents = @collection.documents
  end

  def new
    @collection = Collection.build
    authorize @collection
  end

  def create
    @collection = Collection.build(collection_params)
    @collection.user = Current.user

    if @collection.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "collections",
            partial: "collections/collection",
            collection: Collection.all
          )
        end
        format.html do
          redirect_to collections_path, notice: "The Collection has been created."
        end
      end
    end
  end

  private
  def collection_params
    params.require(:collection).permit(:title, :description)
  end
end
