--反叛的双生子 粉魔
function c80015025.initial_effect(c)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e7:SetCountLimit(1,80015025)
	e7:SetCondition(c80015025.sccon)
	c:RegisterEffect(e7)  
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80015025,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,80015026)
	e1:SetTarget(c80015025.target)
	e1:SetOperation(c80015025.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c80015025.immcon)
	e3:SetOperation(c80015025.immop)
	c:RegisterEffect(e3)
end
function c80015025.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x32d7)
end
function c80015025.sccon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c80015025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80015025.filter(c)
	return c:IsSetCard(0x32d7) and not c:IsCode(80015025) and c:IsAbleToGrave()
end
function c80015025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80015025.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c80015025.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80015025.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local tg=Duel.GetMatchingGroup(c80015025.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(80015025,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c80015025.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80015025.immcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():GetMaterial():IsExists(Card.IsPreviousLocation,3,nil,LOCATION_MZONE)
end
function c80015025.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80015025,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c80015025.tgvalue)
	e1:SetValue(c80015025.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c80015025.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c80015025.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end