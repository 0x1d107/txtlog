from html.parser import HTMLParser
import sys,re

import latex2mathml.converter as l2m

import pygments
from pygments.lexers import guess_lexer,get_lexer_by_name
from pygments.formatters.html import HtmlFormatter

class HTMLProcessor(HTMLParser):
    def __init__(self):
        self.tags=[]
        self.last_data = ""
        self.handlers={}
        self.last_attrs={}
        self.data_handler = lambda x:x
        super().__init__()
    def tag_handler(self,tag_name):
        def decorator(fx):
            self.handlers[tag_name]=fx
            return fx
        return decorator
    def handle_starttag(self, tag, attrs):
        if tag not in self.handlers:
            print(len(self.tags)*'    '+self.get_starttag_text())
        else:
            self.last_attrs = dict(attrs)
        self.tags.append(tag)
    def handle_startendtag(self, tag, attrs):
        print(len(self.tags)*'    '+self.get_starttag_text())
    def handle_data(self, data):
        if data.isspace():
            return
        if self.tags[-1] in self.handlers:
            self.last_data+=data
            return
        tabs = len(self.tags)*'    '
        if 'pre' in self.tags:
            tabs = ''
        else:
            data = data.replace('\n','\n'+tabs)
        print (tabs+self.data_handler(data,self.tags),end='')
    def handle_endtag(self, tag):
        if tag in self.handlers:
            print(self.handlers[tag](self.last_data,self.tags,self.last_attrs))
            self.last_data=''
            self.last_attrs={}
            self.tags.pop()
            return 
        tabs = len(self.tags)*'    '
        if 'pre' ==tag:
            tabs = ''
        self.tags.pop() 
        
        print(tabs+f"</{tag}>")

processor = HTMLProcessor()
@processor.tag_handler('code')
def code_handler(text,tags,attrs):
    if 'pre' == tags[-2]:
        lexer = guess_lexer(text)
        if attrs.get('class','').startswith('language-'):
            try:
                name = attrs['class'][len('language-'):]
                if name == 'nohl':
                    return f"<code>{text}</code>"
                lexer = get_lexer_by_name(name)
            except pygments.util.ClassNotFound as e:
                print(e,file=sys.stderr)
            code = pygments.highlight(text,lexer,HtmlFormatter(nowrap=True)).strip()
            return f"<code>{code}</code>"
    return f"<code>{text}</code>"
def math_replace(match):
    return l2m.convert(match.group(0)[2:-2],display='block' if match[0][1] == '[' else
    'inline')


def math_handler(text,tags):
    if 'pre' in tags or 'script' in tags or 'style' in tags or 'code' in tags or 'body' not in tags:
        return text
    return re.subn(r"\\\[([^\\]|\\[^\]])*\\\]|\\\(([^\\]|\\[^\)])*\\\)",math_replace,text,flags=re.MULTILINE)[0]
processor.data_handler = math_handler

processor.feed(sys.stdin.read())
