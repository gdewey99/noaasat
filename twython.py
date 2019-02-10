from twython import Twython
APP_KEY ='8VZeDR1yykKxlb582SIbIn1z1'
APP_SECRET ='DrkqE5CxBkWfW3h76DFqy9F9k0iUwfKtOUUDVED7AiT8dXoKOR'
OAUTH_TOKEN ='125647195-LvBzLzhC1I4W73A476mcVOEV77U0uqqSld4caVxQ' 
OAUTH_TOKEN_SECRET ='tYS6nwn9ZW0IC8yMmGwu9na1tb8SwTQEZU8xYnIoED0Sn'
twitter = Twython(APP_KEY, APP_SECRET,
                  OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
twitter.update_status(status='See how easy using Twython is!')
