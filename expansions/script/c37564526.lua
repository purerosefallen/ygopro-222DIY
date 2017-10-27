--Wishing in the Dark
local m=37564526
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	Senya.Nanahira(c)
	c:EnableReviveLimit()
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(37564765,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(cm.sptg2)
	e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
end
function cm.matfilter(c,rc)
	return c:IsCanBeRitualMaterial(rc) and c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,nil)
		end
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
		else
			return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
		end
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	local mat=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,c)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
		mat:Merge(mat2)
	end
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	c:CompleteProcedure()
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end