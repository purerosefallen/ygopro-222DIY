--神匠器 鹿丸
function c10126012.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126012,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e1:SetCountLimit(1,10126012)
	e1:SetTarget(c10126012.eqtg)
	e1:SetOperation(c10126012.eqop)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c10126012.efilter)
	c:RegisterEffect(e2)   
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126012,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10126111)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c10126012.spcost)
	e3:SetTarget(c10126012.sptg)
	e3:SetOperation(c10126012.spop)
	c:RegisterEffect(e3)
end
function c10126012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126012.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10126012.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,2,2,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c10126012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10126012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10126012.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c10126012.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10126012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10126012.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126012.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c10126012.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc and Duel.Equip(tp,c,tc,true) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_EQUIP_LIMIT)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetLabelObject(tc)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetValue(c10126012.eqlimit)
	   c:RegisterEffect(e1)
	end
end
function c10126012.eqlimit(e,c)
	return c==e:GetLabelObject()
end