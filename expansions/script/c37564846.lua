--3L·REDALiCE
local m=37564846
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_3L=true
function cm.initial_effect(c)
	--Senya.setreg(c,m,37564800)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp,mg,tc)
	return c:IsType(TYPE_FUSION) and Senya.check_set_3L(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(cm.rfilter,1,tc,tc,c,tp)
end
function cm.rfilter(c,tc,fc,tp)
	local mg=Group.FromCards(c,tc)
	return Senya.CheckFusionMaterialExact(fc,mg,tp)
end
function cm.mfilter(c,e)
	if e and c:IsImmuneToEffect(e) then return false end
	return c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER) and Senya.check_set_3L(c) and c:IsAbleToRemove()
end
function cm.battlecheck(c,tp)
	if c:IsReason(REASON_EFFECT) then return true end
	if not c:IsReason(REASON_BATTLE) then return false end
	local bc=Duel.GetAttacker()
	return c==Duel.GetAttackTarget() and bc and bc:IsControler(1-tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then	  
		if rp==tp or eg:GetCount()~=1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local tc=eg:GetFirst()
		if not Senya.check_set_3L(tc) or not tc:IsType(TYPE_MONSTER) or not tc:IsLocation(LOCATION_GRAVE) or not tc:IsAbleToRemove() or not cm.battlecheck(tc,tp) then return false end
		local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,tc)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsRelateToEffect(e) or not tc:IsAbleToRemove() or tc:IsImmuneToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_DECK,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,tc)
	if g:GetCount()==0 then return end
	local fc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=mg:FilterSelect(tp,cm.rfilter,1,1,tc,tc,fc,tp)
	mat:AddCard(tc)
	fc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	fc:CompleteProcedure()
end