---
to: app/src/models/<%= h.inflection.camelize(name) %>.js
---
<% if (name === userTable) { %>
import bcrypt from 'bcrypt';
<% } %>
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
			<% if (name === userTable) { %>
			hooks: {
				beforeCreate: (<%= name %>) => {
					const salt = bcrypt.genSaltSync();
					<%= name %>.set('<%= userPassword %>', bcrypt.hashSync(<%= name %>.<%= userPassword %>, salt));
				}
			},
			<% } %>
		}
	);
	<% if (name === userTable) { %>
	<%= Name %>.isPassword = (encodedPassword, password) => bcrypt.compareSync(password, encodedPassword);
	<% } %>
	return <%= Name %>;
};
