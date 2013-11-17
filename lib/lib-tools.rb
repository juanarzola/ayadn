#!/usr/bin/ruby
# encoding: utf-8
class AyaDN
	class Tools
		def colorize(contentText)
			content = Array.new
			splitted = contentText.split(" ")
			splitted.each do |word|
				if word =~ /^#/
					content.push(word.pink)
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
        def helpScreen
            help = ""
            help += "- " + "without options: display the Unified stream + your directed posts\n\n"
            help += "- " + "write ".green + "+ [Enter key], or " + "write \"your text\" ".green + "to create a post\n"
            help += "- " + "reply postID ".green + "to reply to a post\n"
            help += "- " + "delete postID ".green + "to delete a post\n"
            help += "- " + "star/unstar postID ".green + "to star/unstar a post\n"
            help += "- " + "repost/unrepost postID ".green + "to repost/unrepost a post\n"
            help += "- " + "infos @username/postID ".green + "to display detailed informations on a user or a post\n"
            help += "- " + "convo postID ".green + "to display the conversation around a post\n"
            help += "- " + "posts @username ".green + "to display a user's posts\n"
            help += "- " + "mentions @username ".green + "to display posts mentionning a user\n"
            help += "- " + "starred @username/postID ".green + "to display a user's starred posts, or who starred a post\n"
            help += "- " + "reposted postID ".green + "to display who reposted a post\n"
            help += "- " + "global/trending/checkins/conversations ".green + "to display one of these streams\n"
            help += "- " + "tag hashtag ".green + "to search for hashtags (don't write the '#')\n"
            help += "- " + "follow/unfollow @username ".green + "to follow/unfollow a user\n"
            help += "- " + "save/load postID ".green + "to save/load a post locally\n"
            help += "- " + "help ".green + "to display this screen. See " + "https://github.com/ericdke/ayadn#how-to-use".magenta + " for detailed instructions, examples and tips." + "\n"
            help += "- some options have a one-letter shortcut: w(rite), r(eply), p(osts), m(entions), t(ag), c(onversations), i(nfos), h(elp).\n\n"
            help += "Examples:\n".cyan
            help += "ayadn.rb ".green + "(display your Unified stream)\n"
            help += "ayadn.rb write ".green + "(write a post with a compose window)\n"
            help += "ayadn.rb write \"Good morning ADN\" ".green + "(write a post instantly between double quotes)\n"
            help += "ayadn.rb reply 14685167 ".green + "(reply to post n°14685167 with a compose window)\n"
            help += "ayadn.rb tag nowplaying ".green + "(search for hashtag #nowplaying)\n"
            help += "ayadn.rb star 14685167 ".green + "(star post n°14685167)\n"
            help += "ayadn.rb checkins ".green + "(display the Checkins stream)\n"
            help += "ayadn.rb follow @ericd ".green + "(follow user @ericd)\n"
            help += "\n"
            return help
        end
	end
end
class String
    def is_integer?
      self.to_i.to_s == self
    end
    def reddish;
        "\033[1;31m#{self}\033[0m"
    end
    def pink;
        "\033[1;35m#{self}\033[0m"
    end
    def black;          
        "\033[30m#{self}\033[0m" 
    end
    def red;            
        "\033[31m#{self}\033[0m" 
    end
    def green;          
        "\033[32m#{self}\033[0m" 
    end
    def brown;          
        "\033[33m#{self}\033[0m" 
    end
    def blue;           
        "\033[34m#{self}\033[0m" 
    end
    def magenta;        
        "\033[35m#{self}\033[0m" 
    end
    def cyan;           
        "\033[36m#{self}\033[0m" 
    end
    def gray;           
        "\033[37m#{self}\033[0m" 
    end
    def bg_black;       
        "\033[40m#{self}\0330m"  
    end
    def bg_red;         
        "\033[41m#{self}\033[0m" 
    end
    def bg_green;       
        "\033[42m#{self}\033[0m" 
    end
    def bg_brown;       
        "\033[43m#{self}\033[0m" 
    end
    def bg_blue;        
        "\033[44m#{self}\033[0m" 
    end
    def bg_magenta;     
        "\033[45m#{self}\033[0m" 
    end
    def bg_cyan;        
        "\033[46m#{self}\033[0m" 
    end
    def bg_gray;        
        "\033[47m#{self}\033[0m" 
    end
    def bold;           
        "\033[1m#{self}\033[22m" 
    end
    def reverse_color;  
        "\033[7m#{self}\033[27m" 
    end
end
class ClientStatus
    def errorNoID
        s = "\nError -> you must give a post ID to reply to.\n\n".red
    end
    def emptyPost
        s = "\nError -> there was no text to post.\n\n".red
    end
    def errorInfos(arg)
        s = "\nError -> ".red + "#{arg}".brown + " isn't a @username or a Post ID\n\n".red
    end
    def errorUserID(arg)
        s = "\nError -> ".red + "#{arg}".brown + " is not a @username\n\n".red
    end
    def errorPostID(arg)
        s = "\nError -> ".red + "#{arg}".brown + " is not a Post ID\n\n".red
    end
    def getUnified
        s = "\nLoading the ".green + "unified ".brown + "Stream...\n".green
    end
    def getExplore(explore)
        s = "\nLoading the ".green + "#{explore}".brown + " stream.".green
    end
    def getGlobal
        s = "\nLoading the ".green + "global ".brown + "Stream...\n".green
    end
    def whoReposted(arg)
        s = "\nLoading informations on post ".green + "#{arg}".brown + "...\n ".green
        s += "\nReposted by: \n".cyan
    end
    def whoStarred(arg)
        s = "\nLoading informations on post ".green + "#{arg}".brown + "...\n".green
        s += "\nStarred by: \n".cyan
    end
    def infosUser(arg)
        s = "\nLoading informations on user ".green + "#{arg}".brown + "...\n".green
    end
    def infosPost(arg)
        s = "\nLoading informations on post ".green + "#{arg}".brown + "...\n".green
    end
    def postsUser(arg)
        s = "\nLoading posts of ".green + "#{arg}".brown + "...\n".green
    end
    def mentionsUser(arg)
        s = "\nLoading posts mentionning ".green + "#{arg}".brown + "...\n".green
    end
    def starsUser(arg)
        s = "\nLoading ".green + "#{arg}".reddish + "'s favorite posts...\n".green
    end
    def starsPost(arg)
        s = "\nLoading users who starred post ".green + "#{arg}".reddish + "...\n" .green
    end
    def getHashtags(arg)
        s = "\nLoading posts containing ".green + "##{arg}".pink + "...\n".green
    end
    def sendPost
        s = "\nSending post...\n".green
    end
    def postSent
        s = "Successfully posted.\n".green
    end
    def deletePost(postID)
        s = "\nDeleting post ".green + "#{postID}".brown + "...\n".green
    end
    def getPostReplies(arg)
        s = "\nLoading the conversation around post ".green + "#{arg}".brown + "...\n".green
    end
    def writePost
        s = "\n256 characters max, validate with [Enter] or cancel with [esc].\n".green
        s += "\nType your text: ".cyan
    end
    def writeReply(arg)
        s = "\nLoading informations of post " + "#{arg}".brown + "...\n".green
    end
    def savingFile(what, path, file)
        s = "\nSaving ".green + "#{what} ".brown + "in ".green + "#{path}#{file}".magenta
    end
end