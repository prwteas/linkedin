module LinkedIn
  module Api
    module CommentMethods

      #
      # get_comments()
      #
      # description: Retrieve comments on a given post and filter
      #              based on optional inputs.
      # inputs:
      #   REQUIRED
      #     :post_id - the id of the post to pull comments from.
      #   OPTIONAL
      #     :count - number of commetns to return
      #     :start - comment number to start pulling from
      #
      # outputs:
      #   Mash of json results from LinkedIn service
      #
      def get_comments(options={})
        options.reverse_merge!({:order => "recency"})
        if options[:post_id]
          post_id = options.delete(:post_id)
        else
          raise ":post_id option required for get_comments method"
        end
        path = "/posts/#{post_id}/comments:(text)"
        simple_query(path, options)
      end
 
    end # CommentMethods
  end # Api
end # LinkedIn
