require "test_helper"

class MarkdownRendererTest < Redcarpet::TestCase

  def setup
    @renderer = Styleguide::MarkdownRenderer
  end


  test "Renders example without options" do
    source = <<-MARKDOWN.strip_heredoc
    ```example
    <p>Renders correctly</p>
    ```
    MARKDOWN

    rendered_output = render(source)

    assert_match "Renders correctly", rendered_output
  end

  test "Renders examples with options" do
    source = <<-MARKDOWN.strip_heredoc
    ```example
    height: "100px"
    width: "100px"
    ---
    <a href="#">test link</a>
    ```
    MARKDOWN

    rendered_output = render(source)

    assert_match 'width="100px"', rendered_output
    assert_match 'height="100px"', rendered_output
    assert_match 'test link', rendered_output
  end

  test "Renders colors" do
    source = <<-MARKDOWN.strip_heredoc
    ```color
    span: 2
    name: "$reviewed-purple-down"
    value: "#090d3d"
    ```
    MARKDOWN

    result = <<-RESULT.strip_heredoc
    <div class="example">
      <div style="background: #090d3d; width: 100px; height: 100px"></div>
    </div>
    <div class="example-source">
      <div class="highlight"><pre class="highlight erb"><code>$reviewed-purple-down</code></pre></div>
    </div>
    RESULT

    rendered_output = render(source)
    assert_match '#090d3d', rendered_output
    assert_match '$reviewed-purple-down', rendered_output
  end


  test "Renders color pallet" do
    source = <<-MARKDOWN.strip_heredoc
    ```color-palette
    colors:
      - {name: "$reviewed-gray-100", value: "#232323"}
      - {name: "$reviewed-gray-200", value: "#474747"}
    ```
    MARKDOWN

    rendered_output = render(source)

    assert_match "#232323", rendered_output
    assert_match "#474747", rendered_output
  end
end
