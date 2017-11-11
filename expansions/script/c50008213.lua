--请问您今天要来跳舞吗
local m=50008213
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if mil.is_series(tc,'rabbit') and tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.MoveSequence(tc,1)
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		e:SetLabel(Duel.SelectOption(tp,70,71,72))
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
		Duel.ConfirmDecktop(1-tp,1)
		local g=Duel.GetDecktopGroup(1-tp,1)
		local tc=g:GetFirst()
		local opt=e:GetLabel()
		if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			local hg=Duel.GetFieldGroup(p,0,LOCATION_HAND)
			local sg=hg:RandomSelect(tp,1)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	end)
	c:RegisterEffect(e2)
end
