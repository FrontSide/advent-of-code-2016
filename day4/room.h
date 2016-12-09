#include <string>

class Room {

    private:
        std::string m_encName;
        int m_id;
        std::string m_checksum;

        std::string computeChecksumFromEncName();

    public:
        Room(std::string roomString);
        void setRoomFromRoomString(std::string roomString);

        bool isReal();
        int getId();

};
