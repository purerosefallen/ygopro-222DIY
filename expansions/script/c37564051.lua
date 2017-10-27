--闪电元灵·轰隆隆
local m=37564051
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37564765,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.rmcon)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE+0x1c0)
	e3:SetCountLimit(1,m-4000)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.xyztg)
	e3:SetOperation(cm.xyzop)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return Senya.check_set_elem(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==4
end
function cm.rmcon(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetMZoneCount(tp)>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	sg:Merge(g)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.xyzfilter(c)
	return Senya.check_set_elem(c) and c:IsXyzSummonable(nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end