--!!Chaos Time!!
local m=37564306
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.list then
		local io=require('io')  
		cm.list={}
		cm.ct=0
		for line in io.lines('lflist.conf') do
			if line=="!2016.7" then break end
			local pos=line:find(" 0")
			if pos then
				local cd=tonumber(line:sub(1,pos-1))
				cm.ct=cm.ct+1
				cm.list[cm.ct]=cd
			end
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.list and cm.list~={} end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local chk=false
	local cd=nil
	local os=require('os')
	math.randomseed(os.time())
	for i=1,100 do
		math.random(cm.ct)
	end
	local token=nil
	while not (token and token:GetType()>0) do
		local cd=cm.list[math.random(cm.ct)]
		token=Duel.CreateToken(tp,cd)
	end
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
	Duel.Hint(HINT_CARD,0,token:GetOriginalCode())
	if token:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SpecialSummon(token,0,tp,tp,true,true,POS_FACEUP)
	else
		Duel.SendtoHand(token,tp,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	end
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():CancelToGrave()
		Duel.SendtoDeck(e:GetHandler(),nil,-1,REASON_RULE)
	end
end
