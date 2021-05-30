# Application Agglobus

## Installation

### Clés API Google

Pour des raisons de sécurité, les clés API Google ne sont pas partagées. Il vous
faudra donc créer des clés API Google, activer SDK Google Maps pour iOS et Android
sur ces clés. Une fois les clés obtenues :

Créez un fichier `android/app/src/main/res/values/api_keys.xml` avec le contenu
suivant :

```xml
<resources>
    <string name="maps_api_key" translatable="false">_VOTRE_CLE_API_</string>
</resources>
```

Puis créez un fichier `ios/Agglobus/ApiKeys.h` avec le contenu suivant :

```objective-c
NSString *MAPS_API_KEY = @"_VOTRE_CLE_API_";
```