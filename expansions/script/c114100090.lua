--魔法との出会い
function c114100090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c114100090.condition)
	e1:SetTarget(c114100090.target)
	e1:SetOperation(c114100090.activate)
	c:RegisterEffect(e1)
end
function c114100090.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL)
end
function c114100090.filter(c,lv)
	return c:IsSetCard(0x221) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() and c:GetLevel()==lv
end
function c114100090.filterbelow(c,lv)
	return c:IsSetCard(0x221) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand() and c:IsLevelBelow(lv)
end
function c114100090.levelf(c,lv)
	return c:GetLevel()==lv
end
function c114100090.confilter(mg)
	local g={}
	for i=1,8 do
		g[i]=mg:Filter(c114100090.levelf,nil,i)
	end
	local con=0
	if g[1]:GetCount()>0 and g[7]:GetCount()>0 then con=con+1 end
	if g[2]:GetCount()>0 and g[6]:GetCount()>0 then con=con+2 end
	if g[3]:GetCount()>0 and g[5]:GetCount()>0 then con=con+4 end
	if g[4]:GetCount()>1 then con=con+8 end
	if g[8]:GetCount()>0 then con=con+16 end
	return con
end
function c114100090.merge(g,lv)
	local bg=g
	if lv==8 then
		local ag=Duel.GetMatchingGroup(c114100090.filter,tp,LOCATION_DECK,0,nil,lv)
		bg:Merge(ag)
	else
		local ag1=Duel.GetMatchingGroup(c114100090.filter,tp,LOCATION_DECK,0,nil,lv)
		local ag2=Duel.GetMatchingGroup(c114100090.filter,tp,LOCATION_DECK,0,nil,8-lv)
		bg:Merge(ag1)
		bg:Merge(ag2)
	end
	return bg
end
function c114100090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mg=Duel.GetMatchingGroup(c114100090.filterbelow,tp,LOCATION_DECK,0,nil,8)
		return c114100090.confilter(mg)>0 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c114100090.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c114100090.filterbelow,tp,LOCATION_DECK,0,nil,8)
	local opt=c114100090.confilter(mg)
	if opt==0 then return end
	local tg=Group.CreateGroup()
	if opt-16>=0 then 
		c114100090.merge(tg,8)
		opt=opt-16
	end
	if opt-8>=0 then 
		c114100090.merge(tg,4)
		opt=opt-8
	end
	if opt-4>=0 then 
		c114100090.merge(tg,3)
		opt=opt-4
	end
	if opt-2>=0 then 
		c114100090.merge(tg,2)
		opt=opt-2
	end	
	if opt-1>=0 then 
		c114100090.merge(tg,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=tg:Select(tp,1,1,nil)
	local g1tc=g1:GetFirst()
	if g1tc:GetLevel()<8 then
		local glv=g1tc:GetLevel()
		local tg2=Duel.GetMatchingGroup(c114100090.filter,tp,LOCATION_DECK,0,g1tc,8-glv)
		local g2=tg2:Select(tp,1,1,nil)
		g1:Merge(g2)
	end
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end