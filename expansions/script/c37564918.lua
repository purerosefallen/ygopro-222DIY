--Sayuri-月光乱舞
local m=37564918
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_sayuri=true
cm.Senya_name_with_rose=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Senya.sayuri_activate_effect[c]=e1
end
function cm.filter(c,e,tp,mg)
	if not Senya.check_set_sayuri(c) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:IsExists(cm.rfilter,1,nil,c)
end
function cm.rfilter(c,rc)
	return c:GetRank()==rc:GetLevel()
end
function cm.exfilter(c)
	return c:IsAbleToRemove() and Senya.check_set_elem(c) and c:IsType(TYPE_XYZ)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_EXTRA,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:FilterSelect(tp,cm.rfilter,1,1,nil,tc)
		tc:SetMaterial(mat)
		Senya.SayuriCheckTrigger(tc,e,tp,eg,ep,ev,re,r,rp)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(cm.rcon)
		e2:SetOperation(cm.rop)
		e2:SetReset(0x1fc1000)
		tc:RegisterEffect(e2,true)
		tc:CopyEffect(mat:GetFirst():GetOriginalCode(),0x1fe1000,1)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function cm.retfilter(c)
	return c:IsFaceup() and c:IsAbleToDeckOrExtraAsCost() and Senya.check_set_sayuri(c) and c:IsType(TYPE_MONSTER)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	return bit.band(r,REASON_COST)~=0 and re:GetHandler()==e:GetHandler() and re:IsHasType(0x7e0) and Duel.IsExistingMatchingCard(cm.retfilter,tp,LOCATION_REMOVED,0,ct,nil)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local ct=bit.band(ev,0xffff)
	Duel.Hint(HINT_CARD,0,e:GetOwner():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.retfilter,tp,LOCATION_REMOVED,0,ct,ct,nil)
	local des=g:IsExists(Card.IsType,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and 0 or 2
	Duel.SendtoDeck(g,nil,des,REASON_COST)
end