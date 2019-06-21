---
to: app/models/<%= h.inflection.camelize(name) %>.js
---

<%
	Name = h.inflection.camelize(name)
%>

<%
	Columns = JSON.parse(columns)
%>

export default (sequelize, DataType) => {
	const <%= Name %> = sequelize.define('<%= Name %>',
		{
			<% for(var i = 0; i < Columns.length; i++) { column = Columns[i] %><%= column.name %>: {
				type: DataType.<%= column.type %>, <% if (column.name === 'id') { %>
				primaryKey: true,
				autoIncrement: true <% } else { %>
				allowNull: false,
				validate: {
					notEmpty: true
				} <% } %>
			}<%= (i === Columns.length -1) ? '' : ',' %><% } %>
		},
		{
			tableName: '<%= name %>',
		}
	);

	return <%= Name %>;
};
