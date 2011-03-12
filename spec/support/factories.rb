saved_single_instances = {}
#Find or create the model instance
single_instances = lambda do |factory_key|
  begin
    saved_single_instances[factory_key].reload
  rescue NoMethodError, ActiveRecord::RecordNotFound
    #was never created (is nil) or was cleared from db
    saved_single_instances[factory_key] = Factory.create(factory_key)  #recreate
  end

  return saved_single_instances[factory_key]
end

Factory.sequence :title do |n|
  "title#{n}"
end
Factory.sequence :email do |n|
    "person#{n}@example.com"
end

Factory.define :pdf do |p|
  p.creator { single_instances[:publisher]}
end

Factory.define :video do |v|
  v.title "My favourite video"
  v.updated_at 2.weeks.ago
  v.creator { single_instances[:publisher] }
end
Factory.define :course do |c|
  c.title "My Course"
  c.creator { single_instances[:publisher] }
end
Factory.define :course_item, :class => "CourseItem" do |c|
  c.amount 1.22
end
  # c.course { Factory(:course) }
  # ci.content { Factory(:pdf) }

Factory.define :image do |i|
  i.status Content::STATUS_COMPLETE
  i.title {Factory.next(:title)}
  i.updated_at 2.weeks.ago
  i.creator { single_instances[:publisher] }
end


Factory.define :publisher do |p|
  p.password "abc123"
  p.email  "abc@123.com"
end
