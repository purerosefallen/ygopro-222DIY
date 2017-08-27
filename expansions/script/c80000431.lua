--ＰＭ 黑眼鳄
function c80000431.initial_effect(c)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(c80000431.splimit)
	c:RegisterEffect(e3) 
	--xyz limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(c80000431.xyzlimit)
	c:RegisterEffect(e4) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,80000431)
	e1:SetCondition(c80000431.spcon)
	e1:SetOperation(c80000431.spop)
	c:RegisterEffect(e1)   
end
function c80000431.splimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_REPTILE)
end
function c80000431.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_REPTILE)
end
function c80000431.filter(c)
	return c:GetSequence()<5 and c:IsAbleToGraveAsCost()
end
function c80000431.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c80000431.filter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c80000431.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c80000431.filter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end