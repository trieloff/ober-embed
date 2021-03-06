<%--

  OEmbed Embedder component.

--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page import="com.adobe.cq.components.oembed.OEmbedRenderer,
  com.adobe.cq.components.oembed.LinkDiscoverer,
  com.adobe.cq.components.oembed.OEmbedType,
  com.day.cq.wcm.api.WCMMode" %><%
    String[] whitelist = currentStyle.get("allowedSites", new String[0]);
    
    boolean isEdit = WCMMode.fromRequest(request) == WCMMode.EDIT;
    String url = properties.get("webpage", String.class);
    
    boolean allowed = true;
    if (whitelist.length>0&&url!=null) {
      allowed = false;
      for (String site : whitelist) {
        if(url.indexOf(site.toLowerCase() + "/")>0) {
          allowed = true;
          break;
        }
      }
    }
    if (!allowed) {
      if (isEdit) {
        %><strong class="error">Your content policy forbids embedding content from this site.</strong><%
      }
    } else if ((url==null||url.length()==0)&&isEdit) {
      %><strong class="error">Please configure the URL to embed</strong><%
    } else {
      LinkDiscoverer renderer = ((OEmbedRenderer) sling.getService(com.adobe.cq.components.oembed.OEmbedLookup.class)).getLinkDiscoverer();
      boolean found = renderer.discoverLink(url);
      if ((!found||renderer.getType()==null)&&isEdit) {
        %><strong class="error">URL <%=url %> cannot be embedded.</strong><%
      } else if (found&&renderer.getType()!=null) {
        if (renderer.getType()==OEmbedType.RICH||renderer.getType()==OEmbedType.VIDEO) {
          %>
            <div class="oembed-rich">
              <%= renderer.getHTML() %>
            </div>
          <%
        } else if (renderer.getType()==OEmbedType.PHOTO) {
          int width = renderer.getWidth();
          int height = renderer.getHeight();
          String photoUrl = renderer.getURL();
          String title = renderer.getTitle();
          %><img src="<%= photoUrl %>" width="<%= width %>" height="<%= height %>" title="<%= title %>"/><%
        } else if (renderer.getType()==OEmbedType.CARD) {
          %>
            <div class="oembed-card">
              <% if (null!=renderer.getThumbnailURL()) { %>
              <a href="<%=url %>" class="oembed-card-link oembed-card-image-link"><img class="oembed-card-image" src="<%=renderer.getThumbnailURL() %>"></a>
              <% } %>
              <h2 class="oembed-card-title"><a href="<%=url %>" class="oembed-card-link oembed-card-title-link"><%=renderer.getTitle() %></a></h2>
              <p class="oembed-card-description"><a href="<%=url %>" class="oembed-card-link oembed-card-description-link"><%=renderer.getHTML() %></a></p>
              <a href="<%=url %>" class="oembed-card-link oembed-card-website-link"><%=url.replaceAll(".*://(www\\.)?","").replaceAll("/.*","") %></a>
            </div>
          <%
        } else if (renderer.getType()==OEmbedType.PLAIN) {
          %><a href="<%=url %>" class="oembed-plain-link"><%=renderer.getTitle() %></a><%
        } else {
          %>trying to embed this stuff <%=renderer.getType() %><%
        }
      }
    }

%>

<%--
<%
      
   	String endpoint = properties.get("endpoint", String.class);
	
   	String webpage = properties.get("webpage", String.class);
	OEmbedRenderer renderer = new OEmbedRenderer();
	boolean found = false;
	if (endpoint != null && url != null) {
		Integer maxWidth = properties.get("maxWidth", Integer.class);
		Integer maxHeight = properties.get("maxHeight", Integer.class);
		found = renderer.fetchResponse(endpoint, url, maxWidth, maxHeight);
    } else if (webpage != null) {
		found = renderer.discoverLink(webpage);
    }
	if (found) {
%><div style="margin-bottom:10px;"><%
		String title = renderer.getTitle();
		if (title == null) { title = "No title"; }
		switch (renderer.getType()) {
	    	case PHOTO:
			int width = renderer.getWidth();
			int height = renderer.getHeight();
			String photoUrl = renderer.getURL();
%><img src="<%= photoUrl %>" width="<%= width %>" height="<%= height %>" title="<%= title %>"/><%
	        break;
	    	case VIDEO:
	    	case RICH:
%><%= renderer.getHTML() %><%
	        break;
	    	case LINK:
%><a href="<%= renderer.getURL() %>"><%= renderer.getTitle() %></a><%
	        break;
	    }
    } else {
%><p style="border">Please configure OEmbed URL</p><%
    }
%></div>
--%>