module.exports =  {
	asAdministrator: function() {
		return this.as('administrator');
	},

	as: function(role) {
		return function(req, res, next) {
			if (req.user && req.user.role === role) return next();
			res.send(401);
		};
	}
};