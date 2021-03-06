<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/wiki/init.jsp" %>

<%
ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);

SocialActivity socialActivity = (SocialActivity)row.getObject();

JSONObject extraDataJSONObject = JSONFactoryUtil.createJSONObject(HtmlUtil.unescape(socialActivity.getExtraData()));

double version = extraDataJSONObject.getDouble("version");

WikiPage wikiPage = (WikiPage)request.getAttribute(WebKeys.WIKI_PAGE);

WikiPage socialActivityPage = WikiPageLocalServiceUtil.getPage(wikiPage.getNodeId(), wikiPage.getTitle(), version);
%>

<liferay-ui:icon-menu>
	<c:if test="<%= (version != wikiPage.getVersion()) && (socialActivityPage.isApproved()) && (WikiPagePermission.contains(permissionChecker, wikiPage, ActionKeys.UPDATE)) %>">
		<portlet:actionURL var="revertURL">
			<portlet:param name="struts_action" value="/wiki/edit_page" />
			<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.REVERT %>" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
			<portlet:param name="nodeId" value="<%= String.valueOf(wikiPage.getNodeId()) %>" />
			<portlet:param name="title" value="<%= HtmlUtil.unescape(wikiPage.getTitle()) %>" />
			<portlet:param name="version" value="<%= String.valueOf(version) %>" />
		</portlet:actionURL>

		<liferay-ui:icon
			image="undo"
			message='<%= LanguageUtil.get(pageContext, "restore-version") + " " + String.valueOf(version) %>'
			url="<%= revertURL %>"
		/>
	</c:if>

	<portlet:renderURL var="compareVersionsURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
		<portlet:param name="struts_action" value="/wiki/select_version" />
		<portlet:param name="redirect" value="<%= currentURL %>" />
		<portlet:param name="nodeId" value="<%= String.valueOf(wikiPage.getNodeId()) %>" />
		<portlet:param name="title" value="<%= HtmlUtil.unescape(wikiPage.getTitle()) %>" />
		<portlet:param name="sourceVersion" value="<%= String.valueOf(version) %>" />
		<portlet:param name="callback" value='<%= renderResponse.getNamespace() + "selectVersion" %>' />
	</portlet:renderURL>

	<%
	String taglibURL = "javascript:Liferay.Util.openWindow({dialog: {width: 300}, id: '" + liferayPortletResponse.getNamespace() + "selectVersion', title: '" + LanguageUtil.get(pageContext, "select-version") + "', uri:'" + HtmlUtil.escapeURL(compareVersionsURL.toString()) + "'});";
	%>

	<liferay-ui:icon
		image="copy"
		label="<%= true %>"
		message="compare-to"
		url="<%= taglibURL %>"
	/>
</liferay-ui:icon-menu>