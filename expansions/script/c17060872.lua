--神装佣兵
function c17060872.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c17060872.matfilter,2)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17060872,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c17060872.atkval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17060872,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c17060872.spcon)
	e3:SetTarget(c17060872.sptg)
	e3:SetOperation(c17060872.spop)
	c:RegisterEffect(e3)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(17060872,3))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c17060872.incon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end
c17060872.is_named_with_God_Equipment=1
c17060872.is_named_with_Mercenary_Arthur=1
c17060872.is_named_with_Million_Arthur=1
function c17060872.God_Equipment(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_God_Equipment
end
function c17060872.Mercenary_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Mercenary_Arthur
end
function c17060872.IsMillion_Arthur(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Million_Arthur
end
function c17060872.infilter(c)
	return c:IsFaceup() and (c17060872.God_Equipment(c) or c17060872.IsMillion_Arthur(c))
end
function c17060872.incon(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c17060872.infilter,nil)>=1
end
function c17060872.spcon(e,c,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():FilterCount(c17060872.infilter,nil)>=2
end
function c17060872.atkval(e,c)
	return c:GetLinkedGroupCount()*500
end
function c17060872.matfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c17060872.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17060872.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c17060872.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c17060872.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17060872.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17060872.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end