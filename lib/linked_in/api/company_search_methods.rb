module LinkedIn
  module Api
    module CompanySearchMethods

      # Public: Search the LinkedIn service for companies
      #
      # options - The Hash options used to refine the selection:
      #           :sort  - Controls the search result order. 
      #           :start - The people record to start the return from.
      #                    Used for page wrapping when the total number
      #                    of records matching the search exceeds count
      #                    (default: 0).
      #           :count - The number of companiy records to return 
      #                    (default: 25).
      #           :companies - The company fields to be returned
      #                        (default: id,name,website-url)
      #           :keywords  - The keywords to search for (optional).
      #
      # Examples
      #
      #    > y linkedin.company_search(:keywords => "social,local",
      #                                :count => 2) 
      #    ---
      #    companies:
      #      _count: 2
      #      _start: 0
      #      total: 8620
      #      all:
      #      - id: 1355
      #        name: DHL
      #        website_url: http://www.dhl.com
      #      - id: 15656
      #        name: AECOM
      #        website_url: www.aecom.com
      #      => nil
      #
      # Returns a Hashie::Mash of the matched companies.
      def company_search(options={})
        options.reverse_merge!({
          :sort => 'relevance',
          :start => 0,
          :count => 25,
          :companies => 'id,name,website-url'
        })

        path = "/company-search:(companies:(#{options[:companies]}))" +
               "?sort=#{options[:sort]}" +
               "&start=#{options[:start]}" +
               "&count=#{options[:count]}"
        
        path += "&keywords=#{CGI.escape(options[:keywords])}" if 
          options[:keywords]

        Mash.from_json(get(path))
      end


      def location(options={})
        path = "/people-search:(facets:(code,buckets:(code,name)))?company-name=microsoft&facets=location"
        simple_query(path)
      end

    end # CompanySearchMethods
  end # Api
end # LinkedIn
