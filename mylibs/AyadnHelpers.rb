# encoding: utf-8
def colorize(contentText)
	content = Array.new
	splitted = contentText.split(" ")
	splitted.each do |word|
		if word =~ /^#/
			content.push(word.blue)
		elsif word =~ /^@/
			content.push(word.red)
		elsif word =~ /^http/ or word =~ /^photos.app.net/ or word =~ /^files.app.net/ or word =~ /^chimp.li/ or word =~ /^bli.ms/
			content.push(word.magenta)
		else
			content.push(word)
		end
	end
	coloredPost = content.join(" ")
end
def buildPost(postHash)
	postString = ""
	postHash.each do |item|
		postText = item['text']
		if postText != nil
			coloredPost = colorize(postText)
		else
			coloredPost = "--Post deleted--".red
		end
		userName = item['user']['username']
		createdAt = item['created_at']
		createdDay = createdAt[0...10]
		createdHour = createdAt[11...19]
		links = item['entities']['links']
		postId = item['id']
		postString += "Post ID: ".cyan + postId.to_s.green
		postString += " - " + "The " + createdDay.cyan + ' at ' + createdHour.cyan + ' by ' + "@".green + userName.green + "\n" + "---\n".brown + coloredPost + "\n" + "---".brown
		if !links.empty?
			postString += "\nLink: ".cyan
			links.each do |link|
				linkURL = link['url']
				postString += linkURL.brown + " \n"
			end
		end
		postString += "\n\n"
	end
	return postString
end
def buildUniquePost(postHash)
	postString = ""
	postText = postHash['text']
	if postText != nil
		coloredPost = colorize(postText)
	else
		coloredPost = "--Post deleted--".red
	end
	userName = postHash['user']['username']
	createdAt = postHash['created_at']
	createdDay = createdAt[0...10]
	createdHour = createdAt[11...19]
	links = postHash['entities']['links']
	postId = postHash['id']
	postString += "Post ID: ".cyan + postId.to_s.green
	postString += " - " + "The " + createdDay.cyan + ' at ' + createdHour.cyan + ' by ' + "@".green + userName.green + " :\n" + "---\n".brown + coloredPost + "\n" + "---".brown
	if !links.empty?
		postString += "\nLink: ".cyan
		links.each do |link|
			linkURL = link['url']
			postString += linkURL.brown + " "
		end
	end
	postString += "\n\n"
	return postString
end
class ErrorWarning
	def errorUsername(arg)
		raise ArgumentError.new("\n\n->".brown + " #{arg}".reddish + " is not a @username\n".red)
	end
	def errorPostID(arg)
		raise ArgumentError.new("\n\n->".brown + " #{arg}".reddish + " is not a Post ID\n".red)
	end
	def errorInfos(arg)
		raise ArgumentError.new("\n\n->".brown + " #{arg}".reddish + " isn't a @username nor a Post ID\n".red)
	end
	def errorHTTP
		raise ArgumentError.new("\n\n-> ".brown + "Connexion error.\n".red)
		exit
	end
	def globalError
		63.times{print "*".reverse_color}
		print "\n"
		26.times{print "-".reverse_color}
		print "UNKNOW ERROR".reverse_color
		25.times{print "-".reverse_color}
		puts "\nDon't hesitate to send me a message -> ".reverse_color + "@ericd" + " to help me debug!".reverse_color
		63.times{print "*".reverse_color}
		return nil
	end
	def syntaxError(arg)
		raise ArgumentError.new("\n\n-> ".brown + "#{arg}".magenta + " is not a valid option\n".red)
	end
	def errorReply(arg)
		raise ArgumentError.new("\n\n-> ".brown + "#{arg}".reddish + " is not a Post ID.".red)
	end
end
class ClientStatus
	def getUnified
		s = "\nLoading the Unified Stream...\n".green
	end
	def getGlobal
		s = "\nLoading the Global Stream...\n".green
	end
	def infosUser(arg)
		s = "\nLoading informations on ".green + "#{arg}...\n".reddish
	end
	def postsUser(arg)
		s = "\nLoading posts of ".green + "#{arg}...\n".reddish
	end
	def mentionsUser(arg)
		s = "\nLoading posts mentionning ".green + "#{arg}...\n".reddish
	end
	def starsUser(arg)
		s = "\nLoading ".green + "#{arg}".reddish + "'s favorite posts...\n".green
	end
	def getHashtags(arg)
		s = "\nLoading posts containing ".green + "##{arg}...\n".blue
	end
	def sendPost
		s = "\nSending post...\n".green
	end
	def getDetails
		s = "\nLoading informations...\n".green
	end
	def getPostReplies(arg)
		s = "Loading the conversation around post ".green + "#{arg}\n".reddish
	end
	def writePost
		s = "\n256 characters max, validate with [Enter] or cancel with [esc].\n".green
		s += "\nType your text: ".cyan
	end
	def writeReply(arg)
		s = "\nLoading informations of post #{arg}...\n".green
	end
end
class String
	def is_integer?
	  self.to_i.to_s == self
	end
end




