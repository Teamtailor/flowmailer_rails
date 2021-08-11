module Mail
  class Message
    def tags(val = nil)
      tags = default("TAGS", val)
      tags.is_a?(String) ? tags.split(/,\W?/) : tags
    end

    def tags=(val)
      header["TAGS"] = val
    end
  end
end
