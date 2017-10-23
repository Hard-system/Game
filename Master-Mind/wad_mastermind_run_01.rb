# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here

require 'sinatra'
require 'data_mapper'
# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_mastermind_gen_01"

# Main program
module OXs_Game
  @input = STDIN
  @output = STDOUT
  g = Game.new(@input, @output)
  playing = true
  input = ""
  menu = ""
  guess = ""
  secret = "XXXX"
  turn = 0
  win = 0
  game = ""

  @output.puts 'Enter "1" runs game in command-line window or "2" runs it in web browser.'
  game = @input.gets.chomp
  if game == "1"
    puts "Command line game"
  elsif game == "2"
    puts "Web-based game"
  else
    puts "Invalid input! No game selected."
    exit
  end
    @table = []
  if game == "1"

  # Any code added to command line game should be added below.
    g.start
    g.created_by
    g.student_id

    g.displaymenu
    g.displaysecret
    number = @input.gets.chomp.to_i

          #------------------------------
            case number
            when 1  #START THE GAME

                    g.cleartable
                    secret = "RGBP"
                    g.gensecret(secret)
                    puts g.displaytable
                    if g.checksecret(g.gensecret(secret)) == 0

                        turn = 0
                          while turn < 12
                            value = @input.gets.chomp.upcase
                             p g.secret
                            if value == "" #display the menu while playing

                              g.displaymenu
                              value = @input.gets.chomp.upcase.to_s
                              if value == '2' #NEW GAME
                                @output.puts("New game....")
                                turn = 0
                                g = Game.new(@input, @output)
                                g.cleartable
                                g.gensecret(secret)
                                puts g.displaytable

                                next # start again the loop: turn is 0 again
                              elsif value == '3' #DISPLAY ANALYSIS
                                g.displayanalysis
                              elsif value == '9' #EXTI THE GAME
                                g.finish
                                break
                              else
                                g.displaymenu
                                @output.puts("You wrote wrong number! Try again!")
                              end
                            end
                                while !(value =~ /^[R|G|B|P]+$/ && value.length == 4)
                                puts "Try again!(choose 4 letters from: 'R','G','B','P', ONLY!)"
                                value = @input.gets.chomp.upcase
                                end

                                g.settableturnvalue(turn, value)
                                puts "You entered: " + value
                                print "Result: "
                                puts g.checkresult(turn)
                                puts g.displaytable
                          #if the answer is == with the secret number then puts "You won the GAME!"
                           if value == g.secret
                              turn = 11
                              puts "You won the game!"
                              g.displayanalysis
                              g.recordAnalysis("analysisrecord.txt")
                              g.finish
                              break
                               #if 12 rounds past and there is not correct answer == to secret number
                              #then puts "You lost the game!"
                          elsif turn == 11 && g.gettableturnvalue(turn) != secret
                              g.displayanalysis
                              #g.readFile(g.displayanalysis)
                              g.recordAnalysis("analysisrecord.txt")
                              g.finish
                              puts "You lost the game!"
                              break
                          else
                            turn +=1
                          end
                        end

                    end

            when 2 #NEW GAME
              @output.puts("You should first start the game press '1'")
            when 3 #ANALYSIS
                @output.puts("You can see analysis while playing the game or after finishing the game!")
            when 9 #EXIT
              finish
              game == ""
            else
              puts "Invalid input! No game selected."
              exit
            end











        # Any code added to command line game should be added above.

     exit  # Does not allow command-line game to run code below relating to web-based version
  end
end
# End modules

# Sinatra routes

  # Any code added to web-based game should be added below.


module OXs_Game
  @input = STDIN
  @output = STDOUT
  $g = Game.new(@input, @output)
end
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/wiki.db")

  class User
    include DataMapper::Resource
    property :id, Serial
    property :username, Text, :required => true, :unique_index => true, :length => 5..12
    property :password, BCryptHash, :required => true
    property :date_joined, DateTime
    property :edit, Boolean, :required =>true, :default =>true
    property :admin, Boolean, :required =>true, :default =>false
    has n, :games
    validates_uniqueness_of :username
  end

  class Game
    include DataMapper::Resource
    property :id, Serial
    property :secret, Text
    property :turns, Text
    belongs_to :user
  end

  DataMapper.finalize.auto_upgrade!

   #HomePage
  get '/' do
    erb :home
  end

  # the About page
  get '/about' do
    erb :about
  end

  #opens the GAME PAGE!!!
  get '/edit' do
    protected!
    $secret1 = "RGBP"
    if @Userz.games.length == 0 || params[:new]
      game = Game.create
      @Userz.games << game
      $g.gensecret($secret1)
      game.secret = $g.secret
      game.turns = ''
      game.save
   end
   game = @Userz.games.last

    $g.cleartable
    $g.secret = game.secret
    turns = game.turns.split(',')

    if params[:guess]
      value = params[:guess].strip
      if value =~ /^[RGBP]{4}$/
        turns << value
        game.turns = turns.join(',')
      end
    end

    turns.each_with_index { |value,turn| $g.settableturnvalue(turn,value) }
    $win = if game.turns.split(',').length > 0
      game.turns.split(',').last == $g.secret
    else
      false
    end
    $loss = !$win && turns.length == 12
    @Userz.save

    erb :edit
  end


#GAME PAGE ------------------------------!


get '/login' do
  erb :login
end

post '/login' do
  $credentials = [params[:username],params[:password]]
  @Users = User.first(:username => $credentials[0])
  if @Users
    if @Users.password == $credentials[1]
      file = File.open("login_record.txt", "a")   # puts the info about updates login of every user changes in the login record txt.
      username = $credentials[0]
      timenow = Time.now.asctime
      message = "#{username} logged in at #{timenow}"
      file.puts message
      file.close
      redirect '/'
    else
      $credentials =['','']
      redirect '/wrongaccount'
    end
  else
    $credentials = ['','']
    redirect '/wrongaccount'
  end
end


get '/wrongaccount' do
  erb :wrongaccount
end
#------------------------------ This account does not exist
get '/user/:uzer' do
  @Userz = User.first(:username =>params[:uzer])
  if @Userz !=nil
    erb :profile
  else
    redirect '/noaccount'
  end
end


get '/createaccount' do
  erb :createaccount
end

get '/logout' do
    $credentials = ['', '']
    redirect '/'
  end

put '/user/:uzer' do
  n = User.first(:username => params[:uzer])
  n.edit = params[:edit]? 1:0
  n.save
  redirect '/'
end

get '/admincontrols' do
  adminonly!
  @list2 = User.all :order => :id.desc
  erb :admincontrols
end

#-------------------------------------------DELETE USER
delete '/user/delete/:uzer' do
  protected!
  n = User.first(:username => params[:uzer])
  if n.username == "Admin"
    erb :denied
  else
    n.destroy
    @list2 = User.all :order => :id.desc
    erb :admincontrols
  end
end
#-------------------------------------------------> Edit user

get '/user/edit/:uzer' do
  protected!
  @user = User.first(:username => params[:uzer])
  if @user.username == "Admin"
    erb :denied
  else
    erb :useredit
  end
end

put '/user/update/:uzer' do          #--- change name
  protected!
  @user = User.first(:username => params[:uzer])
  if @user.username == "Admin"
    erb :denied
  else
    @user.username = params[:new_username]
    @user.save
    redirect '/admincontrols'
  end
end
#-------------------------------------Edit User   <-----


#-----------------------Create Account!

post '/createaccount' do
  n = User.new
  n.username = params[:username]
  n.password = params[:password]
  n.date_joined = Time.now
  if n.username == "Admin" and n.password == "123456"
    n.edit = true
  end
  if n.save == true
    redirect '/accountsuccessful'
  else
    redirect '/wronginfo'
  end
end

#------------Create account in admin controls
post '/admincontrols' do
  adminonly!
  n = User.new
  n.username = params[:username]
  n.password = params[:password]
  n.date_joined = Time.now
  if n.username == "Admin" and n.password == "123456"
    n.edit = true
  end
    n.save
  redirect '/admincontrols'
end




get '/accountsuccessful' do         #--- account created successfully
  erb :accountsuccessful
end

get '/wronginfo' do   #---- The account name already exists or you wrote an account name with less than 5
  erb :wronginfo
end

get '/useredit' do  #--- change user name
  erb :useredit
end

get '/notfound' do #page not found
  erb :notfound
end

get '/noaccount' do  # this account does not exist
  erb :noaccount
end

get '/denied' do   #----- You are not authorised
erb :denied
end


not_found do
  status 404
  redirect '/notfound'
end

helpers do
  def adminonly!
    redirect '/denied' unless admin?
  end

  def admin?
    authorized? && @Userz.admin == true
  end

  def protected!
    if authorized?
      return
    end
    redirect '/denied'
  end

  def authorized?
    if $credentials != nil
      @Userz = User.first(:username => $credentials[0])
      if @Userz
        if @Userz.edit ==true
          return true
        else
          return false
        end
      else
        return false
      end
    end
  end
end



  # Any code added to web-based game should be added above.

# End program
