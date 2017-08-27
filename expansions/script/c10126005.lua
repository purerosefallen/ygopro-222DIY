--反骨的强者 勇
function c10126005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10126005)
	e1:SetCondition(c10126005.spcon)
	e1:SetOperation(c10126005.spop)
	c:RegisterEffect(e1)	  
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(10126005,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetCountLimit(1,10126105)
	e2:SetTarget(c10126005.rmtg)
	e2:SetOperation(c10126005.rmop)
	c:RegisterEffect(e2) 
end
function c10126005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126005.rmfilter,tp,0,0x5c,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x5c)
end
function c10126005.rmfilter(c,tp)
	local ec=c:GetEquipTarget()
	return (not ec or (ec and not ec:IsControler(tp))) and c:IsAbleToRemove()
end
function c10126005.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c10126005.rmfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(10126005,1))) then
		local sg1=g1:RandomSelect(tp,1)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(10126005,2))) then
		local sg2=g2:RandomSelect(tp,1)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(10126005,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c10126005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10126005.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10126005.spfilter1(c,tp)
	local eg=c:GetEquipGroup()
	return eg:GetCount()>=2 and eg:IsExists(c10126005.spfilter2,1,nil,tp)
end
function c10126005.spfilter2(c,tp)
	return c:IsSetCard(0x1335) and (c:IsControler(tp) or c:IsFaceup())
end
function c10126005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10126005.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end