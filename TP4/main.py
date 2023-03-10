#!/usr/bin/env python3

from glob import glob
import os
import OpenGL.GL as GL
import glfw
import numpy as np
import random
import pyrr

abc=0
X=0
Y=0
Z=0
R=0
G=0
B=0


def init_window():
    
    # initialisation de la librairie glfw
    glfw.init()
    
    # paramétrage du context opengl
    glfw.window_hint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.window_hint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.window_hint(glfw.OPENGL_FORWARD_COMPAT, GL.GL_TRUE)
    glfw.window_hint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    
    # création et parametrage de la fenêtre
    glfw.window_hint(glfw.RESIZABLE, False)
    window = glfw.create_window(800, 800, 'OpenGL', None, None)
    
    # parametrage de la fonction de gestion des évènements
    glfw.set_key_callback(window, key_callback)
    
    return window

def init_context(window):
    
    # activation du context OpenGL pour la fenêtre
    glfw.make_context_current(window)
    glfw.swap_interval(1)
    
    # activation de la gestion de la profondeur
    GL.glEnable(GL.GL_DEPTH_TEST)
    
    # choix de la couleur de fond
    GL.glClearColor(0.49, 0, 1.0, 0.5)
    print(f"OpenGL: {GL.glGetString(GL.GL_VERSION).decode('ascii')}")

def init_program():
    prog=create_program_from_file('shader.vert','shader.frag')
    GL.glUseProgram(prog)

def compile_shader(shader_content, shader_type):
    
    # compilation d'un shader donne selon son type
    shader_id = GL.glCreateShader(shader_type)
    GL.glShaderSource(shader_id, shader_content)
    GL.glCompileShader(shader_id)
    success = GL.glGetShaderiv(shader_id, GL.GL_COMPILE_STATUS)
    if not success:
        log = GL.glGetShaderInfoLog(shader_id).decode('ascii')
        print(f'{25*"-"}\nError compiling shader: \n\
            {shader_content}\n{5*"-"}\n{log}\n{25*"-"}')
    return shader_id
        
def create_program( vertex_source, fragment_source):
    
    # creation d'un programme gpu
    vs_id = compile_shader(vertex_source, GL.GL_VERTEX_SHADER)
    fs_id = compile_shader(fragment_source, GL.GL_FRAGMENT_SHADER)
    if vs_id and fs_id:
        program_id = GL.glCreateProgram()
        GL.glAttachShader(program_id, vs_id)
        GL.glAttachShader(program_id, fs_id)
        GL.glLinkProgram(program_id)
        success = GL.glGetProgramiv(program_id, GL.GL_LINK_STATUS)
        if not success:
            log = GL.glGetProgramInfoLog(program_id).decode('ascii')
            print(f'{25*"-"}\nError linking program:\n{log}\n{25*"-"}')
        GL.glDeleteShader(vs_id)
        GL.glDeleteShader(fs_id)
    return program_id

def create_program_from_file(vs_file, fs_file):
    
    # creation d'un programme gpu `a partir de fichiers
    vs_content = open(vs_file, 'r').read() if os.path.exists(vs_file)\
    else print(f'{25*"-"}\nError reading file:\n{vs_file}\n{25*"-"}')
    fs_content = open(fs_file, 'r').read() if os.path.exists(fs_file)\
    else print(f'{25*"-"}\nError reading file:\n{fs_file}\n{25*"-"}')
    return create_program(vs_content, fs_content)

def init_data():
    
    sommets=np.array(((0, 0, 0), (1, 0, 0), (0, 1, 0)), np.float32)
    
    # attribution d'une liste d' ́etat (1 indique la cr ́eation d'une seule liste)
    vao = GL.glGenVertexArrays(1)
    
    # affectation de la liste d' ́etat courante
    GL.glBindVertexArray(vao)
    
    # attribution d’un buffer de donnees (1 indique la cr ́eation d’un seul buffer)
    vbo = GL.glGenBuffers(1)
    
    # affectation du buffer courant
    GL.glBindBuffer(GL.GL_ARRAY_BUFFER, vbo)
    
    # copie des donnees des sommets sur la carte graphique
    GL.glBufferData(GL.GL_ARRAY_BUFFER, sommets, GL.GL_STATIC_DRAW)
    
    # Les deux commandes suivantes sont stock ́ees dans l' ́etat du vao courant
    # Active l'utilisation des donnees de positions
    # (le 0 correspond a la location dans le vertex shader)
    GL.glEnableVertexAttribArray(0)
    
    # Indique comment le buffer courant (dernier vbo "bind ́e")
    # est utilis ́e pour les positions des sommets
    GL.glVertexAttribPointer(0, 3, GL.GL_FLOAT, GL.GL_FALSE, 0, None)

def run(window):
    global abc, X, Y, Z, R, G, B
    
    # boucle d'affichage
    while not glfw.window_should_close(window):
        
        # nettoyage de la fenêtre : fond et profondeur
        GL.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT)
        
        prog = GL.glGetIntegerv(GL.GL_CURRENT_PROGRAM)
        
        loc = GL.glGetUniformLocation(prog, "translation")
        if loc == -1 :
             print("Pas de variable uniforme : translation")
        GL.glUniform4f(loc, X, Y, Z, 0)
       
        rot3 = pyrr.matrix33.create_from_z_rotation(np.pi/2)
        rot4 = pyrr.matrix44.create_from_matrix33(rot3)
        prog = GL.glGetIntegerv(GL.GL_CURRENT_PROGRAM)
        loc = GL.glGetUniformLocation(prog, "rotation")
        GL.glUniformMatrix4fv(loc, 1, GL.GL_FALSE, rot4)
        
        #  l'affichage se fera ici
        GL.glDrawArrays(GL.GL_TRIANGLES, 0, 3)

        #affiche le temps que la fenetre a ete ouverte
        print(glfw.get_time())
        if abc<=60:
            abc+=1
        else:
            abc=0
        GL.glClearColor(random.random(), random.random(), random.random(),random.random())
        # gestion des évènements
        glfw.poll_events()

def key_callback(win, key, scancode, action, mods):
    global X, Y,R, G, B
    # sortie du programme si appui sur la touche 'echap'
    if key == glfw.KEY_ESCAPE and action == glfw.PRESS:
        glfw.set_window_should_close(win, glfw.TRUE)
        
    if key == glfw.KEY_R and action == glfw.PRESS:
        R=1
        B=0
        G=0
        
    if key == glfw.KEY_G and action == glfw.PRESS:
        R=0
        B=0
        G=1
        
    if key == glfw.KEY_B and action == glfw.PRESS:
        R=0
        B=1
        G=0
        
    if key == glfw.KEY_LEFT and (action == glfw.PRESS or action == glfw.REPEAT) :
        X+=-0.1
        
    if key == glfw.KEY_RIGHT and (action == glfw.PRESS or action == glfw.REPEAT):
        X+=0.1
        
    if key == glfw.KEY_UP and (action == glfw.PRESS or action == glfw.REPEAT):
        Y+=0.1
        
    if key == glfw.KEY_DOWN and (action == glfw.PRESS or action == glfw.REPEAT):
        Y+=-0.1
    
    if key == glfw.KEY_I and (action == glfw.PRESS or action == glfw.REPEAT):
        
        
    if key == glfw.KEY_J and (action == glfw.PRESS or action == glfw.REPEAT):       
    
    if key == glfw.KEY_K and (action == glfw.PRESS or action == glfw.REPEAT):
    
    if key == glfw.KEY_L and (action == glfw.PRESS or action == glfw.REPEAT):       

def main():
    window = init_window()
    init_context(window)
    init_program()
    init_data()
    run(window)
    glfw.terminate()

if __name__ == '__main__':
    main()