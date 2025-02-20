const AUTH_USER=''' 
 user {
            id
            name
             is_verified
id_color
info
open_time
close_time
total_views
communities{
id
}
unread_notifications_count
            seller_name
            email_verified_at
            email
            level
         address
            phone
            is_seller
            image
            logo
            total_balance
            total_point
            following_count
           invoices_count
invoices_seller_count
         
            info
            following_count
            total_balance
            total_point
            is_seller
            can_create_channel
            can_create_group
           affiliate
            social{
              twitter
              face
              instagram
              linkedin
              tiktok
            }
           
            plans{
            id
            ads_count
            pivot{
             expired_date
            }
            }
            
             city {
                name
                id
                 city_id
            }
            followers {
                seller{
               
                id
            
                }
            }
        }
''';

const AUTH_FIELDS='''
            id
            name
             is_verified
             invoices_count
invoices_seller_count
id_color
info
open_time
close_time
total_views
communities{
id
}
unread_notifications_count
            seller_name
            email_verified_at
            email
            level
         address
            phone
            is_seller
            image
            logo
            total_balance
            total_point
            following_count
           affiliate
         
            info
            following_count
            total_balance
            total_point
            is_seller
            can_create_channel
            can_create_group
           
            social{
              twitter
              face
              instagram
              linkedin
              tiktok
            }
           
            plans{
            id
            ads_count
            pivot{
             expired_date
            }
            }
            
             city {
                name
                id
                city_id
            }
            followers {
                seller{
               
                id
            
                }
            }
''';