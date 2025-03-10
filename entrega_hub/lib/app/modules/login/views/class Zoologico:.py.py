class Zoologico:
    animais = []


class Animal:
    def __init__(self, especie, classe, tamanho, peso):
        self.especie = especie
        self.classe = classe
        self.tamanho = tamanho
        self.peso = peso


class Gerente:
        
    def set_especie(self):
        especie = input("insira um nome ")
        return especie

    def set_classe(self):
        classe = input("insira uma especie ")
        return classe

    def set_tamanho(self):
        tamanho = float(input("insira o tamanho "))
        return tamanho
    
    def set_peso(self):
        peso = float(input("insira o peso "))
        return peso
    
    def cadastrar_animais(self):
        animais = Zoologico().animais
        especie = gerente.set_especie()
        classe = gerente.set_classe()
        tamanho = gerente.set_tamanho()
        peso = gerente.set_peso()
        animal = Animal(especie, classe, tamanho, peso)
        animais.append(animal)
        for i in animais:
            print(i.especie)








class Guia:
    pass



gerente = Gerente()
gerente.cadastrar_animais()





