module LinkedIn
  module Api

    module QueryMethods

      def profile(options={})
        path = person_path(options)
        simple_query(path, options)
      end

      def connections(options={})
        path = "#{person_path(options)}/connections"
        simple_query(path, options)
      end

      def network_updates(options={})
        path = "#{person_path(options)}/network/updates"
        simple_query(path, options)
      end

      def company(options = {})
        path   = company_path(options)
        simple_query(path, options)
      end


      private

        def simple_query(path, options={})
          fields = options.delete(:fields) || LinkedIn.default_profile_fields

          if options.delete(:public)
            path +=":public"
          elsif fields
            path +=":(#{fields.map{ |f| f.to_s.gsub("_","-") }.join(',')})"
          end
          
          headers = options.delete(:headers) || {}
          params  = options.map { |k,v| "#{k}=#{v}" }.join("&")
          path   += "?#{params}" if not params.empty?

          Mash.from_json(get(path, headers))
        end

        def person_path(options)
          path = "/people/"
          if id = options.delete(:id)
            path += "id=#{id}"
          elsif url = options.delete(:url)
            path += "url=#{CGI.escape(url)}"
          else
            path += "~"
          end
        end

        def company_path(options)
          # We leave out the trailing slash because it is used by keys but not
          # by filters
          path = "/companies"
          
          # Add a trailing slash for keys (i.e. input values that return one
          # company)
          if id = options.delete(:id)
            path += "/id=#{id}"
          elsif url = options.delete(:url)
            path += "/url=#{CGI.escape(url)}"
          elsif name = options.delete(:name)
            path += "/universal-name=#{CGI.escape(name)}"
          # Add a question mark for filters (i.e. input values that return
          # an array of companies.
          elsif domain = options.delete(:domain)
            path += "?email-domain=#{CGI.escape(domain)}"
          else
            path += "~"
          end
        end

    end

  end
end
