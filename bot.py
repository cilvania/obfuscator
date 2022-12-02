import discord
from discord.ext import commands
import os
import requests
from subprocess import check_output

bot = commands.Bot(command_prefix="!")
bot.remove_command("help")

file_path = os.path.abspath(os.path.dirname(__file__))

def saveid(id):
    file = open(f"{file_path}//ids.txt")
    if(id in file.read()):
        print("present")
    else:
        f = open(f"{file_path}//ids.txt", 'a')
        f.write(f'\n{id}')
        f.close()

def isid(id):
    file = open(f"{file_path}//ids.txt")
    if(id in file.read()):
        return True
    else:
        return False

def obfuscate(url):
    input_file = f'{file_path}//temp//input.lua'

    if os.path.exists(input_file):
        os.remove(input_file)

    file_data = requests.get(url).content
    with open(input_file, "wb") as file:
        file.write(file_data)

    p = check_output(['node', "C:\\Users\\Administrator\\Desktop\\src\\run.js"])

    x = "herrtt's obfuscator, v0.2.4"
    y = "ylean_ 	herrtt's FREE obfuscator - https://discord.gg/ATcuD9eXqq"

    with open(f"{file_path}//temp//output-1.lua", 'r') as file :
        filedata = file.read()
    filedata = filedata.replace(x, y)
    with open(f"{file_path}//temp//output-1.lua", 'w') as file:
        file.write(filedata)

@bot.event
async def on_ready():
    print(f"{bot.user} is online ✔️")
    await bot.change_presence(status=discord.Status.online, activity=discord.Game(name="?invites"))

@bot.event
async def on_message(message: discord.Message):
    if message.guild is None and not message.author.bot:
        try:
            if isid(str(message.author.id)):
                if message.attachments:
                    if '.lua' not in message.attachments[0].url:
                        embed=discord.Embed(title=f"***Wrong file extension!***", description=f"only ``.lua`` allowed", color=0xFF3357)
                        await message.channel.send(embed=embed)
                    else:
                        print(message.attachments[0].url)
                        obfuscate(message.attachments[0].url)
                        embed=discord.Embed(title="File has been obfuscated", color=0x3357FF)
                        await message.channel.send(embed=embed, file=discord.File(f"{file_path}//temp//output-1.lua"))
                else:
                    embed=discord.Embed(title=f"***Send me .lua file***", description=f"only ``.lua`` file attachment allowed", color=0xFF3357)
                    await message.channel.send(embed=embed)
            else:
                    embed=discord.Embed(title=f"***Not enough invites!***", description=f"Invite 2 friends to this server: https://discord.gg/ATcuD9eXqq\n to gain access to advanced lua obfuscator", color=0xFF3357)
                    await message.channel.send(embed=embed)            
        except:
            pass
    else:
        if message.content.startswith('?invites'):
            if message.channel.id == 970290262158999604:
                totalInvites=0
                for i in await message.guild.invites():
                    if i.inviter == message.author:
                        totalInvites += i.uses
                if totalInvites >= 2:
                    saveid(str(message.author.id))
                embed=discord.Embed(title=f"You've invited {totalInvites} member{'' if totalInvites == 1 else 's'} to the server!", color=0xACFFBA)
                await message.channel.send(embed=embed)
            else:
                await message.delete()
                embed=discord.Embed(title=f"***Wrong command usage!***", description=f"Use **?invites** command only at ``#❓・invites`` channel", color=0xFF3357)
                await message.author.send(embed=embed)   
                      
        if message.content.startswith('?help'):
            if message.author.guild_permissions.administrator:
                embed=discord.Embed(title=f"Invite 2 friends to this server to gain FREE access to advanced lua obfuscator :))\nCheck your invites status by running this command: ``?invites``", color=0xE9019A)
                await message.channel.send(embed=embed)
                await message.channel.send("```Example input file:```", file=discord.File(f"{file_path}//example-input.lua"))
                await message.channel.send("```Example output file:```", file=discord.File(f"{file_path}//example-output.lua"))

        if message.content.startswith('?sy'):
            if message.author.guild_permissions.administrator:
                embed = discord.Embed(title="yunglean_#4171 services", description="``- custom-made c# apps,\n- custom-made lua scripts,\n- custom-made discord bots,\n- custom-made python apps,\n- custom-made apis,``\n\n***Podejmuję się również pisania kolosów z zakresu języka c#, posiadam pozytywne referencje od studentów WSB oraz polibudy poznańskiej.***\n```Portfolio:```\nhttps://github.com/yunglean4171\nhttps://www.youtube.com/channel/UCfOC-q8Fe69REYjY7tBNItA", color=0xE9019A)
                embed.set_thumbnail(url="https://www.emojiall.com/images/60/blobmoji/emoji_u2699.png")
                await message.channel.send(embed=embed)

        if message.content.startswith('?ap'):
            if message.author.guild_permissions.administrator:
                embed = discord.Embed(title="Affiliate program", description=":flag_pl:\n***Chcesz zarobić na mojej pracy? Jeśli uważasz, że komuś przyda się moja usługa, poleć mnie. Otrzymasz 20% wydanych przez tą osobę kosztów. Natychmiastowe wypłaty nagród realizowane są przez paypal/revolut/BLIK/przelew. Jeśli nie posiadasz wymienionych wyżej sposobów płatności, kupię PSC jak tylko nagrody z programu będą wyższe lub równe 20 pln.***\n:flag_us:\n***Do you want to make money on my work? If you think that someone will find my service useful, recommend me. You will receive 20% of the cost spent by that person. Reward payments are made via paypal/revolut.***", color=0xE9019A)
                embed.set_thumbnail(url="https://i.imgur.com/IBhC6sZ.png")
                await message.channel.send(embed=embed)
                
bot.run("TOKEN")
