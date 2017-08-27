--玫瑰之妖精 幻想
function c80004006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(2,80004006)
	e1:SetCondition(c80004006.spcon)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80004006,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(2,80004007)
	e2:SetCondition(c80004006.condition)
	e2:SetTarget(c80004006.target)
	e2:SetOperation(c80004006.operation)
	c:RegisterEffect(e2)  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c80004006.indcon)
	e3:SetOperation(c80004006.indop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCondition(c80004006.efcon)
	c:RegisterEffect(e4)
end
function c80004006.filter(c)
	return c:IsFaceup() and (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)) or (c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_WIND))
end
function c80004006.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80004006.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c80004006.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c80004006.filter1(c,e,tp)
	return (c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_WIND)) or (c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(7)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80004006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80004006.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c80004006.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c80004006.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80004006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c80004006.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c80004006.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c80004006.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80004006,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end