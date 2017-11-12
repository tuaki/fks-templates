#requires python3
import sys, csv, argparse
import xml.etree.ElementTree as ET
from datetime import datetime

parser = argparse.ArgumentParser(description='Preprocess data for diplomas and certificate.')
parser.add_argument('-y', '--year', type=int, required=True, help='year of the event (e. g. \'6\', not academic year)')
parser.add_argument('-d', '--date', type=lambda d: datetime.strptime(d, '%Y-%m-%d'), required=True, help='date when event takes place (in format %%Y-%%m-%%d)')
parser.add_argument('-O', '--output', required=True, help='output CSV file')
parser.add_argument('-I', '--input', required=True, help='input XML file')
parser.add_argument('procType', choices=['diplom', 'certificate'], help='type of process')
args = parser.parse_args()


def getCategoryName(category, lang='cs'):
    catNames = {
        'cs': {'A': 'A', 'B': 'B', 'C': 'C', 'F': 'zahraniční SŠ', 'O': 'open'},
        'en': {'A': 'high school A', 'B': 'high school B', 'C': 'high school C', 'F': 'high school outside of the Czech Republic', 'O': 'open'}
        }
    return catNames[lang][category]

def getLocalizedDate(date, lang='cs'):
    months = {
        'cs': ('ledna', 'února', 'března', 'dubna', 'května', 'června', 'července', 'srpna', 'září', 'října', 'listopadu', 'prosince'),
        'en': ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')
        }
    if lang == 'cs':
        return "{d.day}. {month} {d.year}".format(d=date, month=months[lang][date.month-1])
    elif lang == 'en':
        return "{d.day}{sep}\\, {month}\\, {d.year}".format(d=date, month=months[lang][date.month-1], sep=getEnRank(date.day))
    else:
        raise ValueError('lang must be in (\'cs\',\'en\')')

def texEscape(string):
    string = string.replace("\\","\\textbackslash")
    string = string.replace("_","\\_")
    string = string.replace("&","\\&")
    string = string.replace("{","\\{")
    string = string.replace("}","\\}")
    string = string.replace("%","\\%")
    string = string.replace("$","\\$")
    string = string.replace("#","\\#")
    string = string.replace("~","\\textasciitilde")
    string = string.replace("^","\\textasciicircum")
    return string

def unicodeEscape(string):
    '''
    really ugly thing
    change problematic unicode characters to something different
    '''
    string = string.replace("α","\\boldmath$\\alpha$")
    string = string.replace("π","\\boldmath$\\pi$")
    string = string.replace("∨","\\boldmath$\\vee$")
    return string

def getEnRank(rocnik):
    if ((rocnik%10) == 1 and (rocnik%100) != 11):
        return "^{st}"
    elif ((rocnik%10) == 2 and (rocnik%100) != 12):
        return "^{nd}"
    elif ((rocnik%10) == 3 and (rocnik%100) != 13):
        return "^{rd}"
    else:
        return "^{th}"

def createParticipantsList(schools, persons):
    membFinal = ''
    for school in set(schools):
        indexes = [i for i, j in enumerate(schools) if j == school]
        for k in indexes:
            membFinal += persons[k]
            membFinal += ', '
        membFinal = membFinal[:-2] + ' ('
        if len(indexes) > 1:
            membFinal += str(len(indexes)) + 'x '
        membFinal += school + '), '
    return membFinal[:-2]

def createTeamData(teamLine, eventYear, eventDate):
    teamName = unicodeEscape(texEscape(teamLine['name']))
    members = teamLine['členové'][:-1].replace('}; ', '}').split('}')
    categoryCS = getCategoryName(teamLine['category'], 'cs')
    categoryEN = getCategoryName(teamLine['category'], 'en')
    rankCategory = teamLine['rank_category']
    
    schools = []
    persons = []
    for member in members:
        tmp = member.replace(' {', '{').split('{')
        persons.append(tmp[0])
        schools.append(tmp[1])
    participantsList = texEscape(createParticipantsList(schools, persons))
    if rankCategory == 'None':
        return ((teamName, categoryCS, participantsList, 'XX', 'cs', eventYear, getLocalizedDate(eventDate, 'cs')),
            (teamName, categoryEN, participantsList, 'XX', 'en', str(eventYear)+getEnRank(eventYear), getLocalizedDate(eventDate, 'en')))
    else:
        return ((teamName, categoryCS, participantsList, rankCategory, 'cs', eventYear, getLocalizedDate(eventDate, 'cs')),
            (teamName, categoryEN, participantsList, rankCategory+getEnRank(int(rankCategory)), 'en', str(eventYear)+getEnRank(eventYear), getLocalizedDate(eventDate, 'en')))

def createCertificateData(data, eventYear, eventDate):
    total = next(filter(lambda x: x['Country ISO'] == 'Celkem', data))
    teams = total['Počet týmů']
    participants = total['Počet účastníků']
    countries = len(list(filter(lambda x: len(x['Country ISO']) == 2, data)))
    return (('cs', eventYear, getLocalizedDate(eventDate, 'cs'), teams, participants, countries),
        ('en', str(eventYear)+getEnRank(eventYear), getLocalizedDate(eventDate, 'en'), teams, participants, countries))

def parseXML(filename):
    tree = ET.parse(filename)
    root = tree.getroot().find('.//export')
    columns = []
    data = []
    for columnDefinition in root.find('column-definitions').findall('column-definition'):
        columns.append(columnDefinition.get('name'))
    for row in root.find('data').findall('row'):
        rowData = {}
        for i, col in enumerate(row.findall('col')):
            rowData[columns[i]] = str(col.text)
        data.append(rowData)
    return data


lines = parseXML(args.input)
output = []
if args.procType == 'diplom':
    header = ('JmenoTymu', 'Kategorie', 'ClenoveTymu', 'Poradi', 'Jazyk', 'Rocnik', 'Datum')
    output.append(header)
    catOutput = {'A': [], 'B': [], 'C': [], 'F': [], 'O': []}
    #for line in sorted(lines, key=lambda x: int(x['rank_category'])):
    for line in lines:
        teamData = createTeamData(line, args.year, args.date)
        if(line['category'] in ('A','B','C','O')):
            catOutput[line['category']].append(teamData[0])
        if(line['category'] in ('F','O')):
            catOutput[line['category']].append(teamData[1])
    output.extend(catOutput['A'])
    output.extend(catOutput['B'])
    output.extend(catOutput['C'])
    output.extend(catOutput['F'])
    output.extend(catOutput['O'])
elif args.procType == 'certificate':
    header = ('Jazyk', 'Rocnik', 'Datum', 'PocetTymu', 'PocetUcastniku', 'PocetZemi')
    output.append(header)
    certData = createCertificateData(lines, args.year, args.date)
    output.append(certData[0])
    output.append(certData[1])
else:
    raise ValueError('procType must be in (\'diplom\', \'certificate\')')

with open(args.output, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f, delimiter=';')
    for line in output:
        writer.writerow(line)
