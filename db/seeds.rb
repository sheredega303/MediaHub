%w[admin manager member].each { |role| Role.find_or_create_by(name: role) }
