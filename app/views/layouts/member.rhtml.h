<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>

<head>
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
<meta name="description" content="早鳥網 一個幫助你早起的地方"/>
<meta name="keywords" content="早起,早鳥,早睡,作息時間,早起團,早安,紀錄,iwakela,early,bird,birds,earlybird,earlybirds"/> 
<meta name="author" content="lake"/> 
<%= stylesheet_link_tag "defaults", "itunes", "eb" %>
<%#= javascript_include_tag :defaults %>
<%= javascript_include_tag "flot/excanvas" %>
<%= javascript_include_tag "flot/jquery" %>
<%= javascript_include_tag "flot/jquery.flot.js" %>
<title>早鳥網 一個紀錄幫助你早起的地方</title>
<%= yield :page_spec %>
</head>

<body>
<div class="top_bar">
   <%= render :partial => "shared/auth"%>
</div>

<hr>

<div class="container">
	
  <div class="main">


		<div class="header">
		
			<div class="title">
        <h1 class="ebhead"><%= @user.name %>的早起紀錄</h1>
			</div>

		</div>
		
		<div class="content">
	
			<div class="item">
        <%= show_messages %>
        <%= yield%>
			</div>

		</div>

    <div class="sidenav">
      <%#= render :partial => "shared/search" -%>
			<h1>統計</h1>
      <ul>
          <%= render :partial => "shared/census"%>
      </ul>

			<h1>紀錄</h1>
			<ul>
				<li>
          <%= button_to '我起床了',:controller => 'member', :action => 'wake_up' %>
          (紀錄現在時間)
        </li>
			</ul>

			<h1>功能列表</h1>
      <ul>
          <%= link_tab([
                        [ '首頁', 'main', 'index' ],
                        [ '我的起床紀錄', 'member', 'list'],
                        [ '早鳥團', 'groups', 'index' ],
                        [ '早鳥嘰嘰喳喳', 'chats', 'list' ],
                        [ '早鳥排行榜', 'user', 'list_user_rank' ],
                        [ '早鳥討論區', 'forums', 'index' ],
                        [ '使用者列表', 'user', 'list' ]
                      ]) %>
                    </ul>

		</div>
	
		<div class="clearer"><span></span></div>

	</div>

  <div class="footer">
   <%= render :partial => "shared/footer"%>
 </div>
 <!-- google analytic -->
  <script type="text/javascript">
    var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
    document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
  </script>
  <script type="text/javascript">
    var pageTracker = _gat._getTracker("UA-4497093-1");
    pageTracker._initData();
    pageTracker._trackPageview();
  </script>
</div>

</body>

</html>
