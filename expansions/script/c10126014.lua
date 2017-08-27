--神匠阵法 匠魂阵
function c10126014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10126014)
	e1:SetTarget(c10126014.target)
	e1:SetOperation(c10126014.activate)
	c:RegisterEffect(e1)	  
	--reequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126014,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10126014)
	e2:SetTarget(c10126014.eqtg)
	e2:SetOperation(c10126014.eqop)
	c:RegisterEffect(e2) 
end
function c10126014.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10126014.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10126014.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126014.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	   local tc=Duel.SelectMatchingCard(tp,c10126014.eqfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	   if tc and Duel.Equip(tp,c,tc)~=0 then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e1:SetReset(RESET_EVENT+0x47e0000)
		   e1:SetValue(LOCATION_DECKBOT)
		   c:RegisterEffect(e1,true)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_EQUIP_LIMIT)
		   e2:SetReset(RESET_EVENT+0x1fe0000)
		   e2:SetValue(c10126011.eqlimit)
		   e2:SetLabelObject(tc)
		   c:RegisterEffect(e2)
	   end
end
function c10126014.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10126014.filter(c)
	return c:IsSetCard(0x335) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c10126014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126014.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10126014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10126014.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

