class SearchController < ApplicationController

  TYPE_ORDER = %w[
    issue
    topic
    representative
    parliament_issue
    proposition
    promise
  ]

  def all
    response = nil

    ActiveSupport::Notifications.instrument("search.all", :query => params[:query]) {
      response = Hdo::Search::Searcher.new(params[:query]).all
    }

    @results = []

    if response.success?
      @results = response.results.
                          group_by { |e| e.type }.
                          sort_by { |t, _| TYPE_ORDER.index(t) || 10 }
    else
      flash.alert = t('app.errors.search')
    end
  end

  def autocomplete
    response = Hdo::Search::Searcher.new(params[:query]).autocomplete
    @results = []

    icons = {
      'representative' => view_context.asset_path("representative.png"),
      'issue'          => view_context.asset_path("issue.png")
    }

    if response.success?
      @results = response.results.map do |r|
        url = url_for(controller: r.type.pluralize, action: "show", id: r.slug || r.id)
        img = icons.fetch(r.type)

        r.as_json.merge(
          url: url,
          img_src: img
        )
      end.group_by { |e| e[:_type] }

      respond_to do |format|
        format.json { render json: @results }
      end
    end
  end

end
