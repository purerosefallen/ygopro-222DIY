--水歌 终奏的senya
function c12003002.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetCountLimit(1,12003102)
	e1:SetTarget(c12003002.extg)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12003002,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12003002)
	e2:SetCondition(c12003002.spcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12003002,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c12003002.target)
	e3:SetOperation(c12003002.operation)
	c:RegisterEffect(e3)
	
end
function c12003002.tfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT)
end
function c12003002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12003002.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c12003002.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c12003002.operation(e,tp,eg,ep,ev,re,r,rp)
	  local tc=Duel.GetFirstTarget()
	  if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
	  Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c12003002.extg(e,c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_SEASERPENT)
end
function c12003002.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT)
end
function c12003002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c12003002.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
