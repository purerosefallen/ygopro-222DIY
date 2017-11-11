--请问您今天要来游泳吗？
local m=50008214
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c)
		return mil.is_series(c,'rabbit')
	end,4,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(
	function(e,se,sp,st)
		return e:GetHandler():GetLocation()~=LOCATION_EXTRA
	end)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(
	function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil)
		local sg=Group.CreateGroup()
		return mg:IsExists(cm.fselect,1,nil,tp,mg,sg)
	end)
	e2:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp,c)
		local mg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE,0,nil)
		local sg=Group.CreateGroup()
		while sg:GetCount()<4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=mg:FilterSelect(tp,cm.fselect,1,1,sg,tp,mg,sg)
			sg:Merge(g)
		end
		local cg=sg:Filter(Card.IsFacedown,nil)
		if cg:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cg)
		end
		Duel.SendtoHand(sg,nil,2,REASON_COST)
	end)
	c:RegisterEffect(e2)
	--return hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
		if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	end)
	e3:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65536818,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
	end)
	e4:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e4:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,3,3,nil)
			Duel.ConfirmCards(1-tp,sg)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tc=sg:Select(1-tp,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleDeck(tp)
			sg:RemoveCard(tc)
			local tcs=sg:GetFirst()
			local num=0
			while tcs do
				Duel.MoveSequence(tcs,0)
				tcs=sg:GetNext()
				num=num+1
			end
			Duel.SortDecktop(tp,tp,num)
		end
	end)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function cm.spfilter(c)
	return mil.is_series(c,'rabbit') and c:IsCanBeFusionMaterial() and (c:IsAbleToExtraAsCost() or c:IsAbleToHandAsCost())
end
function cm.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<4 then
		res=mg:IsExists(cm.fselect,1,sg,tp,mg,sg)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function cm.thfilter(c)
	return mil.is_series(c,'rabbit') and c:IsAbleToHand()
end