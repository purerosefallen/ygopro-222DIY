--绝对条件 奇犽
local m=50000074
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c50000074.spfilter,2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50000074,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50000074)
	e1:SetCondition(c50000074.drcon)
	e1:SetTarget(c50000074.drtg)
	e1:SetOperation(c50000074.drop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50000073,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,500000741)
	e2:SetTarget(c50000074.sptg)
	e2:SetOperation(c50000074.spop)
	c:RegisterEffect(e2)
	--atk&def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetValue(500)
	e5:SetTarget(c50000074.ad)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
---
function c50000074.filter(c,e,tp)
	return c:IsSetCard(0x50c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c50000074.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c50000074.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c50000074.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=Duel.GetMZoneCount(tp)
	if ct>1 then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50000074.filter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c50000074.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 or ft<sg:GetCount() or (sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
---
function c50000074.ad(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x50c)
end
---
function c50000074.spfilter(c,e,tp)
	return c:IsSetCard(0x50c)
end

function c50000074.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50000074.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=e:GetHandler():GetMutualLinkedGroupCount()
	if chk==0 then return gc>0 and Duel.IsPlayerCanDraw(tp,gc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c50000074.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=e:GetHandler():GetMutualLinkedGroupCount()
	if gc>0 then
		Duel.Draw(p,gc,REASON_EFFECT)
	end
end