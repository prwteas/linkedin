module LinkedIn
  module Api
    module PeopleSearchMethods

      # Public: Search the LinkedIn service for people
      #
      # options - The Hash options used to refine the selection:
      #           :people - The people fields to be returned 
      #                     (default: public-profile-url,id,first-name,
      #                               last-name,headline,location).
      #           :count  - The number of people records to return
      #                     (default: 25).
      #           :start  - The people record to start the return from.
      #                     Used for page wrapping when the total number
      #                     of records matching the search exceeds count
      #                     (default: 0).
      #           :companies - A comma separated list of company codes to
      #                        to match against the current-company field
      #                        of people (optional).
      #           :locations - A comma separated list of location codes to
      #                        match agains the location field of people
      #                        (optional).
      #           :get_all - Boolean variable telling us to get all of 
      #                      the people that match our search. LinkedIn
      #                      will only return the first 25 by default
      #                      (optional).
      #
      # Examples
      #
      #   > y client.people_search(:locations => 'us:91', 
      #                            :company => 1035, 
      #                            :count => 1)
      #  ---
      #  people:
      #    _count: 1
      #    _start: 0
      #    total: 110
      #    all:
      #    - first_name: Ben
      #      headline: Designer at SkB Architects
      #      id: EHp0p-X67f
      #      last_name: Humphrey
      #      location:
      #        country:
      #          code: us
      #        name: Greater Seattle Area
      #      public_profile_url: http://www.linkedin.com/in/benhumphrey
      #   => nil
      #
      # Returns a Hashie::Mash of the matched people. 
      def people_search(options={})

        # revere merge defaults into options has so that we don't 
        # overwrite what the user has given us.
        options.reverse_merge!({
          :people => "public-profile-url,id,first-name,last-name" +
                     ",headline,location",
          :count  => 25,
          :start  => 0
        })

        # initialize path string for a people-search
        path = "/people-search:(people:(#{options[:people]}))" +
               "?count=#{options[:count]}" +
               "&start=#{options[:start]}"

        # add a facet so that we find everyone in the given companys
        # if the :company option is defined.
        path += "&facet=current-company,#{options[:companies]}" if 
          options[:companies]

        # add a facet so that we find everyone in the given locations
        # if the :location option is defined.
        path += "&facet=location,#{CGI.escape(options[:locations])}" if
          options[:locations]

        # hit the linkedin service with the search. we store the payload
        # as an array so that we can manipulate it below.
        payload = MultiJson.decode(get(path))
        Rails.logger.debug path

        # if the :get_all option is set, we check to make sure that
        # the count of items returned from the linkedin service is 
        # not less than the total number of items that match our 
        # search in the linkedin service. 
        while ((payload['people']['_start'] +
                payload['people']['_count']) <
                payload['people']['_total'])

          # update the path string so that we start from where we 
          # left off from the last search.
          path.sub!(/start=\d+/, 
                    "start=#{payload['people']['_start'] + 
                             payload['people']['_count']}")
          Rails.logger.debug path

          # update the count in our payload
          payload['people']['_count'] += options[:count]

          # hit the linkedin service again and merge teh new 
          # results into our payload.
          payload['people']['values'] += 
            MultiJson.decode(get(path))['people']['values']

        end if options[:get_all]

        Mash.from_json(MultiJson.encode(payload))

      end # people_search()
    end # PeopleSearchMethods
  end # Api
end # LinkedIn
