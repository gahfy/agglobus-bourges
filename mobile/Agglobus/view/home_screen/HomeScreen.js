import {Dimensions, StyleSheet, View} from "react-native";
import React from "react";
import MapView, {PROVIDER_GOOGLE} from "react-native-maps";
import { StatusBar } from 'react-native';
import { Platform } from 'react-native';

const styles = StyleSheet.create({
    containerLandscape: {
        flex:1,
        flexDirection: 'row-reverse'
    },
    containerPortrait: {
        flex:1,
        flexDirection: 'column'
    },
    mapContainer: {
        flex:.5,
    },
    map: {
        ...StyleSheet.absoluteFillObject
    },
    other: {
        flex:.5
    },
});

export default class HomeScreen extends React.Component {

    constructor(props) {
        super(props);

        /**
         * Returns true if the screen is in portrait mode
         */
        const isPortrait = () => {
            const dim = Dimensions.get('window');
            return dim.height >= dim.width;
        };

        this.state = {
            orientation: isPortrait() ? 'portrait' : 'landscape'
        };

        // Event Listener for orientation changes
        Dimensions.addEventListener('change', () => {
            this.setState({
                orientation: isPortrait() ? 'portrait' : 'landscape'
            });
        });

        StatusBar.setBarStyle('dark-content', true);
    }

    componentDidMount() {
        if(Platform.OS === 'android') {
            StatusBar.setTranslucent(true);
            StatusBar.setBackgroundColor("transparent");
        }
    }

    render() {
        return (
            <View style={ this.state.orientation === "portrait" ? styles.containerPortrait : styles.containerLandscape }>
                <View style={styles.mapContainer}>
                    <MapView
                        provider={PROVIDER_GOOGLE}
                        style={styles.map}
                        initialRegion={{
                            latitude: 47.08476,
                            longitude: 2.39589,
                            latitudeDelta: 0.01,
                            longitudeDelta: 0.01,
                        }}
                    />
                </View>
                <View style={styles.other} />
            </View>
        );
    }
}