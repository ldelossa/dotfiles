import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';

class Profilectl extends Service {
    static {
        Service.register(this, {}, {
            'profile': ['string', 'r'],
            'mode': ['string', 'r'],
        });
    }

    #profile = 'balanced';

    /** @param {'performance' | 'balanced' | 'power-saver'} prof */
    setProfile(prof) {
        Utils.execAsync(`powerprofilesctl set  ${prof}`)
            .then(() => {
                this.#profile = prof;
                this.changed('profile');
            })
            .catch(console.error);
    }

    constructor() {
        super();

        if (Utils.exec('which asusctl')) {
            this.available = true;
            this.#profile = Utils.exec('powerprofilectl get');
        }
        else {
            this.available = false;
        }
    }

    /** @returns {['performance', 'balanced', 'power-saver']} */
    get profiles() { return ['performance', 'balanced', 'power-saver']; }
    get profile() { return this.#profile; }
}

export default new Profilectl();
