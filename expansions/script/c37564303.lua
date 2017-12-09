--new utakat
local m=37564303
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local ct=Senya.master_rule_3_flag and 3 or 2
	Senya.AddXyzProcedureRank(c,nil,nil,ct,ct)
	Senya.AddSummonMusic(c,aux.Stringid(m,4),SUMMON_TYPE_XYZ)
	Senya.MokouReborn(c,7,m,false,cm.dogcon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(0x14000)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
end
function cm.dogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:GetPreviousControler()==tp and rp~=tp) then return false end
	if c:IsReason(REASON_EFFECT) then return true end
	local bc=Duel.GetAttacker()
	return c:IsReason(REASON_BATTLE) and c==Duel.GetAttackTarget() and bc and bc:IsControler(1-tp)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
end
function cm.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToChangeControler()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()==0 then return end
	local gc=g:RandomSelect(tp,1):GetFirst()
	for i=0,3 do
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,i))
	end
	Duel.Overlay(c,Group.FromCards(gc))
	if c:GetOverlayGroup():IsContains(gc) then
		Senya.CopyStatusAndEffect(e,nil,gc,true)
	end
end