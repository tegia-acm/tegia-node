#include <string>
#include <regex>

#include <tegia2/core/contacts/email.h>



namespace tegia {
namespace contacts {


///////////////////////////////////////////////////////////////////////////////////////////
/*

*/
///////////////////////////////////////////////////////////////////////////////////////////

email_t::email_t():contact_t("email")
{
	
};


email_t::email_t(const std::string &value):contact_t("email")
{
	this->parse(value);
};


///////////////////////////////////////////////////////////////////////////////////////////
/*

*/
///////////////////////////////////////////////////////////////////////////////////////////


std::string email_t::value() const
{
	return this->_email;
};


///////////////////////////////////////////////////////////////////////////////////////////
/*

*/
///////////////////////////////////////////////////////////////////////////////////////////


bool email_t::parse(const std::string &value)
{
	this->_email = value;
	return true;
};


///////////////////////////////////////////////////////////////////////////////////////////
/*

*/
///////////////////////////////////////////////////////////////////////////////////////////




}	// END namespace contacts
}	// END namespace tegia