# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

module PostHelper

  def gen_header
    content = "<span class='pre noprint docinfo top'>[<a href='/' title='Home page'>Home</a>] [<a href='' title='Plaintext version of this document'>txt</a>|<a href='' title='PDF version of this document'>pdf</a>] [<a href='/' title='Site map'>Map</a>]                                                  </span><br />
    <span class='pre noprint docinfo'>             ПЕРВАЯ СТРОКА                                              </span><br />                               
    <span class='pre noprint docinfo'>  ВТОРАЯ                          ШАБЛОН ШАПКИ           STANDARD HEADER</span><br />                               
    <span class='pre noprint docinfo'>        ТРЕТЬЯ                                          <span style='color: #C00;'>ВАЖНОЕ СООБЩЕНИЕ</span></span><br />"
    return content
  end

  def get_pretty_date(post)
    attribute_to_time(post[:created_at]).strftime('%B %-d, %Y')
  end

  def get_url_list(links)
#    links.split(" ").each { |i| 
#      output += i
#    }
    return links
  end

  def get_post_start(post)
      content = post.compiled_content
      if content =~ /\s<!-- more -->\s/
        content = content.partition('<!-- more -->').first +
        "<div><a href='#{post.path}'>Continue reading &rsaquo;</a></div>"
      end
      return content
  end
end

include PostHelper

